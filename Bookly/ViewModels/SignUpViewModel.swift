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
    
    private let formValidator = FormValidator()
    
    var canSubmit: Bool {
        
        formValidator.validateSignUp(firstName: firstName, lastName: lastName, email: email, password: password)
        
    }
}
