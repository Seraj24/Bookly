//
//  BooklyApp.swift
//  Bookly
//
//  Created by user938962 on 2/4/26.
//

import SwiftUI
import CoreData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        // Seed Database, if needed
        Task {
            do {
                try await FirestoreBootstrapService.shared.uploadSeedDataIfNeeded()
            } catch {
                print("Firestore bootstrap failed: \(error.localizedDescription)")
            }
        }
        
        return true
        
    }
    
}

@main
struct BooklyApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var holder: BooklyHolder
    
    init() {
        let context = persistenceController.container.viewContext
        _holder = StateObject(wrappedValue: BooklyHolder(context))
        
    }
    
    var body: some Scene {
        WindowGroup {
            let ctx = persistenceController.container.viewContext
            ContentView()
                .environment(\.managedObjectContext, ctx)
                .environmentObject(holder)
                .task {
                    let loader = BooklyDataLoader(context: ctx, holder: holder)
                    await loader.loadInitialData()
                }
        }
    }
}
