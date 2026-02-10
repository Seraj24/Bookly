//
//  SignInView.swift
//  Bookly
//
//  Created by user938962 on 2/4/26.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject private var vm: SignInViewModel = SignInViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            FormHeader(title: "Sign In", subtitle: "Access the best deals for your next trip.")
                

            ScrollView {
                VStack(spacing: 14) {
                    VStack(spacing: 12) {
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
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2, y: 1)

                    HStack {
                        Spacer()
                        Button("Forgot password?") {
                            // TODO
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                    }

                    Button {
                        vm.signInTapped()
                    } label: {
                        Label("Sign In", systemImage: "airplane.arrival")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .fontWeight(.semibold)
                    .buttonStyle(.borderedProminent)
                    .disabled(!vm.canSubmit)
                    .opacity(vm.canSubmit ? 1 : 0.6)


                    NavigationLink("Continue as guest") {
                        HomeView()
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)


                    HStack(spacing: 6) {
                        Text("New here?")
                            .foregroundStyle(.secondary)

                        NavigationLink("Create an account") {
                            SignUpView()
                        }
                        .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .navigationTitle("Bookly")
        .navigationBarTitleDisplayMode(.inline)
        .background(.white)
    }
}
    
    
#Preview {
    NavigationStack {
        SignInView()
    }
}
