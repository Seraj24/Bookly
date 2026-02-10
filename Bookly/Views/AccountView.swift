//
//  AccountView.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import SwiftUI

struct AccountView: View {
    
    @StateObject private var vm: AccountViewModel
    
    init(appUser: AppUser) {
        _vm = StateObject(wrappedValue: AccountViewModel(appUser: appUser))
    }
    
    var body: some View {
        Text("Planned for the next deliverable")
    }
}

#Preview {
    AccountView(appUser: AppUser(id: "1", email: "test@test.com", displayName: "Test User"))
}

