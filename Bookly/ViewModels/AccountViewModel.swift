//
//  AccountViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine

final class AccountViewModel: ObservableObject {
    
    private var auth = AuthService.shared
    
    var appUser: AppUser?
    
    init() {
        appUser = auth.currentUser
    }
    
    func logOut() {
        auth.signOut()
    }
    
    
    
}

