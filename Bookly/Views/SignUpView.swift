//
//  SignUpView.swift
//  Bookly
//
//  Created by user938962 on 2/4/26.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var vm: SignUpViewModel = SignUpViewModel()

    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                headerSection
                
                form
                
                signUpButton
                
                feedbackSection
                
                signInRow
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            vm.configure(holder: holder, context: context)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Bookly")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color("BrandNavy"))
            
            Text("Sign Up")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.primary)
            
            Text("You are a few clicks away from the world.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }
    
    private var form: some View {
        VStack(spacing: 18) {
            
            VStack(alignment: .leading, spacing: 6) {
                
                InputField(
                    title: "First name",
                    systemImage: "person",
                    text: $vm.firstName,
                    placeholder: "John",
                    textContentType: .givenName,
                    autoCapitalization: .words
                )
                
                if let error = vm.errorMessage(for: .firstName) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                InputField(
                    title: "Last name",
                    systemImage: "person",
                    text: $vm.lastName,
                    placeholder: "Doe",
                    textContentType: .familyName,
                    autoCapitalization: .words
                )
                
                if let error = vm.errorMessage(for: .lastName) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                InputField(
                    title: "Email",
                    systemImage: "at",
                    text: $vm.email,
                    placeholder: "Email",
                    textContentType: .emailAddress,
                    keyboardType: .emailAddress,
                    disableAutoCorrection: true,
                    autoCapitalization: .never
                )
                
                if let error = vm.errorMessage(for: .email) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                InputField(
                    title: "Password",
                    systemImage: "lock",
                    text: $vm.password,
                    placeholder: "At least 6 characters",
                    textContentType: .newPassword,
                    disableAutoCorrection: true,
                    autoCapitalization: .never,
                    isSecure: true
                )
                
                if let error = vm.errorMessage(for: .password) {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            
        }
        .padding(.vertical, 10)
    }
    

    private var signUpButton: some View {
        Button {
            vm.CreateAccount()
        } label: {
            Label("Sign Up", systemImage: "airplane.departure")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .fontWeight(.semibold)
        .buttonStyle(.borderedProminent)
        .tint(Color("BrandNavy"))
        .disabled(!vm.canSubmit)
        .opacity(vm.canSubmit ? 1 : 0.6)
    }
    
    @ViewBuilder
    private var feedbackSection: some View {
        VStack(spacing: 8) {
            if let errorMessage = vm.errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if vm.createdSuccessfully {
                Text("Account created successfully. You can now sign in.")
                    .font(.footnote)
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var signInRow: some View {
        HStack(spacing: 6) {
            Text("Already have an account?")
                .foregroundStyle(.secondary)
            
            NavigationLink("Sign In") {
                SignInView()
            }
            .fontWeight(.semibold)
            .foregroundStyle(Color("PrimaryColor"))
        }
        .font(.footnote)
        .padding(.top, 4)
    }
}
#Preview {
    NavigationStack { SignUpView() }
}
