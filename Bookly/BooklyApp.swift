//
//  BooklyApp.swift
//  Bookly
//
//  Created by user938962 on 2/4/26.
//

import SwiftUI
import CoreData

@main
struct BooklyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
