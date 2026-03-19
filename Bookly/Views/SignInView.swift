//
//  SignInView.swift
//  Bookly
//
//  Created by user938962 on 2/4/26.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @Environment(\.managedObjectContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm: SignInViewModel = SignInViewModel()

    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                headerSection
                
                form
                
                forgotPasswordRow
                
                signInButton
                
                errorText
                
                guestLink
                
                signUpRow
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
            
            Text("Sign In")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.primary)
            
            Text("Access the best deals for your next trip.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }
    
    private var form: some View {
        VStack(spacing: 18) {
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
                textContentType: .password,
                disableAutoCorrection: true,
                autoCapitalization: .never,
                isSecure: true
            )
        }
        .padding(.vertical, 10)
    }
    
    private var forgotPasswordRow: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {
                // TODO
            }
            .font(.footnote)
            .foregroundStyle(Color("PrimaryColor"))
        }
    }
    
    private var signInButton: some View {
        Button {
            vm.signInTapped()
            if (vm.errorMessage == nil) {
                dismiss()
            }
        } label: {
            Label("Sign In", systemImage: "airplane.arrival")
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
    private var errorText: some View {
        if let errorMessage = vm.errorMessage, !errorMessage.isEmpty {
            Text(errorMessage)
                .font(.footnote)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var guestLink: some View {
        Button("Continue as guest") {
            vm.continueAsGuest()
        }
        .buttonStyle(.bordered)
        .frame(height: 36)
        .padding(.top, 4)
    }
    
    private var signUpRow: some View {
        HStack(spacing: 6) {
            Text("New here?")
                .foregroundStyle(.secondary)
            
            NavigationLink("Create an account") {
                SignUpView()
            }
            .fontWeight(.semibold)
            .foregroundStyle(Color("PrimaryColor"))
        }
        .font(.footnote)
        .padding(.top, 4)
    }
}
    
    
#Preview {
    NavigationStack {
        SignInView()
    }
}
