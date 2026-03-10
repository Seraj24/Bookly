//
//  FormValidator.swift
//  Bookly
//
//  Created by user938962 on 2/9/26.
//

import Foundation

enum SignUpField {
    case firstName
    case lastName
    case email
    case password
}

struct FormValidator {
    
    func validateRequired(_ value: String, fieldName: String) -> String? {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? "\(fieldName) is required"
        : nil
    }

    func validateFirstName(_ value: String) -> String? {
        validateRequired(value, fieldName: "First name")
    }

    func validateLastName(_ value: String) -> String? {
        validateRequired(value, fieldName: "Last name")
    }

    func validateEmail(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "Email is required" }
        
        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return trimmed.range(of: emailRegex, options: [.regularExpression, .caseInsensitive]) == nil
        ? "Invalid email address"
        : nil
        
    }

    func validatePassword(_ value: String) -> String? {
        value.count < 6 ? "Password must be at least 6 characters" : nil
        
    }

    func validateSignIn(email: String, password: String) -> Bool {
        validateEmail(email) == nil &&
        validatePassword(password) == nil
    }

    func validateSignUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) -> [SignUpField: String] {
        
        var errors: [SignUpField: String] = [:]

        if let error = validateFirstName(firstName) {
            errors[.firstName] = error
        }

        if let error = validateLastName(lastName) {
            errors[.lastName] = error
        }

        if let error = validateEmail(email) {
            errors[.email] = error
        }

        if let error = validatePassword(password) {
            errors[.password] = error
        }

        return errors
    }
    
}

struct SimpleError: Error {
    
    
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    var localizedDescription: String { message }
}
