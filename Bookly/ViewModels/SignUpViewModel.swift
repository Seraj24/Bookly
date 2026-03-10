//
//  SignUpViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/9/26.
//

import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var showPassword = false
    @Published var errorMessage: String?
    @Published var createdSuccessfully = false
    
    @Published var errors: [SignUpField: String] = [:]
    
    private var auth = AuthService.shared
    
    private let formValidator = FormValidator()
    
    func errorMessage(for field: SignUpField) -> String? {
            errors[field]
    }
    
    var canSubmit: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }
    
    func CreateAccount() {
        
        let validationErrors = formValidator.validateSignUp(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )
                
        errors = validationErrors
                
        guard validationErrors.isEmpty else { return }
        
        auth.signUp(firstName: firstName, lastName: lastName, email: email, passwrod: password) { result in
            switch result {
            case .success(let success):
                self.errorMessage = nil
                self.createdSuccessfully = true
            case .failure(let failure):
                self.errorMessage = "Failed to create an account. Please check your input and then try again."
            }
        }
    }
}
