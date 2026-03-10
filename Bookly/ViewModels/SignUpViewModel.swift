//
//  SignUpViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/9/26.
//

import Foundation
import Combine
import CoreData

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
    
    private var holder: BooklyHolder?
    private var context: NSManagedObjectContext?
    
    
    private let formValidator = FormValidator()

    
    func errorMessage(for field: SignUpField) -> String? {
            errors[field]
    }
    
    func configure(holder: BooklyHolder, context: NSManagedObjectContext) {
        self.holder = holder
        self.context = context
        
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
        
        guard let holder, let context else { return }
        
        
        auth.signUp(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            holder: holder,
            context: context
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.errorMessage = nil
                    self.createdSuccessfully = true
                case .failure(let err):
                    self.createdSuccessfully = false
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }
}
