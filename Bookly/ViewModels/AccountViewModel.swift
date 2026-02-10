//
//  AccountViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine

final class AccountViewModel: ObservableObject {
    
    let appUser: AppUser
    
    init(appUser: AppUser) {
        self.appUser = appUser
    }
}

