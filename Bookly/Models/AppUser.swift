//
//  AppUser.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import FirebaseFirestore

struct AppUser: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    let email: String
    let firstName: String
    let lastName: String
    var isActive: Bool = true

}
