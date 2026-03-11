//
//  AccountViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine
import CoreData

final class AccountViewModel: ObservableObject {
    
    private let auth = AuthService.shared
    
    private var holder: BooklyHolder?
    private var context: NSManagedObjectContext?
    
    @Published var appUser: AppUser?
    
    init() {
        self.appUser = auth.currentUser
    }
    
    func configure(holder: BooklyHolder, context: NSManagedObjectContext) {
        self.holder = holder
        self.context = context
        
    }
    
    func signIn() {
        auth.isGuest = false
    }
    
    func logOut() {
        
        guard let holder, let context else { return }
        
        let result = auth.signOut(holder: holder, context: context)
        
        switch result {
        case .success:
            appUser = nil
        case .failure(let error):
            print("Logout failed: \(error.localizedDescription)")
        }
    }
    
    func refreshUser() {
        appUser = auth.currentUser
    }
}

