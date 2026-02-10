//
//  AppUser.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation

struct AppUser: Identifiable, Codable, Hashable {
    
    var id: String
    let email: String
    var displayName: String
    var isActive: Bool = true

}
