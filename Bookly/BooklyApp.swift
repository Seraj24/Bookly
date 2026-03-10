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
        
        return true
        
    }
    
}

@main
struct BooklyApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            let ctx = persistenceController.container.viewContext
            ContentView()
                .environment(\.managedObjectContext, ctx)
                .environmentObject(BooklyHolder(ctx))
        }
    }
}
