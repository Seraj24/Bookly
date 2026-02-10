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
    @Published var errorMessage: String?
    
    private var auth = AuthService.shared
    
    private let formValidator = FormValidator()
    
    
    var canSubmit: Bool {
        formValidator.validateSignIn(email: email, password: password)
    }
    
    func signInTapped() {
        auth.login(email: email, password: password) { result in
            switch result {
            case .success:
                self.errorMessage = nil
            case .failure(let err):
                self.errorMessage = err.localizedDescription
            }
        }
    }
}
