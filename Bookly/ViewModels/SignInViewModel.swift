//
//  SignInViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine
import CoreData

final class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    private var auth = AuthService.shared
    
    private var holder: BooklyHolder?
    private var context: NSManagedObjectContext?
        
    
    private let formValidator = FormValidator()
      
    
    var canSubmit: Bool {
        formValidator.validateSignIn(email: email, password: password)
    }
    
    func configure(holder: BooklyHolder, context: NSManagedObjectContext) {
        self.holder = holder
        self.context = context
        
    }
    
    func continueAsGuest() {
        auth.isGuest = true
    }
    
    func signInTapped() {
        
        guard let holder, let context else { return }
        
        auth.login(
            email: email,
            password: password,
            holder: holder,
            context: context
        )
        { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.errorMessage = nil
                case .failure(let err):
                    self.errorMessage = "Invalid Email or Password"
                    
                }
            }
            
        }
    }
}
