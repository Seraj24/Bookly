//
//  AccountView.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import SwiftUI

struct AccountView: View {
    
    @StateObject private var vm: AccountViewModel
    
    init() {
        _vm = StateObject(wrappedValue: AccountViewModel())
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            List {
                Section("Account Details") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Account")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        if let user = vm.appUser {
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.headline)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Not signed in")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Button(role: .destructive) {
                    vm.logOut()
                } label: {
                    Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .background(.clear)
            
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    AccountView()
}

