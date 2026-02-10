//
//  SignUpView.swift
//  Bookly
//
//  Created by user938962 on 2/4/26.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var vm: SignUpViewModel = SignUpViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            FormHeader(title: "Sign Up", subtitle: "You are a few clicks away from the world")
            
            Form {
                Section {
                    
                    InputField(
                        title: "First name",
                        systemImage: "person",
                        text: $vm.firstName,
                        placeholder: "John",
                        textContentType: .givenName,
                        autoCapitalization: .words
                    )
                    
                    InputField(
                        title: "Last name",
                        systemImage: "person",
                        text: $vm.lastName,
                        placeholder: "Doe",
                        textContentType: .familyName,
                        autoCapitalization: .words
                    )
                    
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
                }
                
                Text("Use at least 6 characters. Avoid using your name.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
        }
        
            VStack {
                
                Button {
                    //TODO
                } label: {
                    Label("Sign In", systemImage: "airplane.departure")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .fontWeight(.semibold)
                .buttonStyle(.borderedProminent)
                .disabled(!vm.canSubmit)
                .opacity(vm.canSubmit ? 1 : 0.6)
                
                
                HStack(spacing: 6) {
                    Text("Already have an account?")
                        .foregroundStyle(.secondary)
                    
                    NavigationLink("Sign In") {
                        SignInView()
                    }
                    .fontWeight(.semibold)
                }
                .font(.footnote)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGroupedBackground))
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        
        
        
        }
        .navigationTitle("Bookly")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { SignUpView() }
}
