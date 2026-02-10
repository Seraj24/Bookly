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
    
    private var auth = AuthService.shared
    
    private let formValidator = FormValidator()
    
    var canSubmit: Bool {
        
        formValidator.validateSignUp(firstName: firstName, lastName: lastName, email: email, password: password)
        
    }
    
    func CreateAccount() {
        
        auth.signUp(firstName: firstName, lastName: lastName, email: email, passwrod: password) { result in
            switch result {
            case .success(let success):
                self.errorMessage = nil
                self.createdSuccessfully = true
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
            }
        }
    }
}
