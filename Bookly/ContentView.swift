//
//  ContentView.swift
//  Bookly
//
//  Created by user938962 on 2/4/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var auth = AuthService.shared

    var body: some View {
        Group {
            if auth.currentUser != nil || auth.isGuest {
                TabView {
                    NavigationStack {
                        HomeView()
                    }
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    
                    NavigationStack {
                        SearchView()
                    }
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    
                    NavigationStack {
                        AccountView()
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    
                }
            } else {
                NavigationStack {
                    SignInView()
                }
                
            }
            
            
        }
    }

}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
