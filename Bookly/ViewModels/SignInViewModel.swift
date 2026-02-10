//
//  SignInViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    private let formValidator = FormValidator()
    
    
    var canSubmit: Bool {
        formValidator.validateSignIn(email: email, password: password)
    }
    
    func signInTapped() {
        
    }
    
    
}
