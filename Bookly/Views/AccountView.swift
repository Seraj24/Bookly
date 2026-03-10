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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                
                accountCard
                
                actionButton
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Account")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Manage your profile and travel activity.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var accountCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let user = vm.appUser {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.headline)
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Upcoming Trips")
                        .font(.headline)
                    
                    Text("Your upcoming bookings will appear here.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rate Your Previous Trips")
                        .font(.headline)
                    
                    Text("Your completed trips and ratings will appear here.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Not signed in")
                        .font(.headline)
                    
                    Text("Sign in to view your trips, bookings, and account details.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
    
    @ViewBuilder
    private var actionButton: some View {
        if vm.appUser == nil {
            NavigationLink {
                SignInView()
            } label: {
                Label("Sign In", systemImage: "person.crop.circle.badge.plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("PrimaryColor"))
            
        } else {
            Button(role: .destructive) {
                vm.logOut()
            } label: {
                Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AccountView()
}

