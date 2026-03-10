//
//  AuthService.swift
//  Bookly
//
//  Created by user938962 on 2/10/26.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import CoreData

class AuthService: ObservableObject {
    
    static let shared = AuthService()
    
    @Published var currentUser: AppUser?
    
    @Published var isGuest: Bool = false
    
    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        holder: BooklyHolder,
        context: NSManagedObjectContext,
        completion: @escaping (Result<AppUser, Error>) -> Void
    ) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(SimpleError("No user found")))
                return
            }
            
            let uid = user.uid
            let safeEmail = user.email ?? email
            
            DispatchQueue.main.async {
                
                let appUser = holder.createUser(
                    id: uid,
                    firstName: firstName,
                    lastName: lastName,
                    email: safeEmail,
                    isActive: true,
                    context
                )
                
                let data: [String: Any] = [
                    "id": uid,
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": safeEmail,
                    "isActive": true
                ]
                
                Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .setData(data) { error in
                        
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        self.currentUser = appUser
                        completion(.success(appUser))
                    }
            }
        }
    }
    
        func login(
            email: String,
            password: String,
            holder: BooklyHolder,
            context: NSManagedObjectContext,
            completion: @escaping (Result<AppUser, Error>) -> Void
        ) {
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let user = result?.user else {
                    completion(.failure(SimpleError("No user found")))
                    return
                }
                
                let uid = user.uid
                
                DispatchQueue.main.async {
                    
                    if let existingUser = holder.fetchUser(byId: uid, context) {
                        
                        existingUser.isActive = true
                        holder.saveContext(context)
                        
                        self.currentUser = existingUser
                        completion(.success(existingUser))
                        
                    } else {
                        
                        let safeEmail = user.email ?? email
                        
                        let appUser = holder.createUser(
                            id: uid,
                            firstName: "",
                            lastName: "",
                            email: safeEmail,
                            isActive: true,
                            context
                        )
                        
                        self.currentUser = appUser
                        completion(.success(appUser))
                    }
                }
            }
        }
        
        func fetchCurrentAppUser(
            holder: BooklyHolder,
            context: NSManagedObjectContext,
            completion: @escaping (Result<AppUser?, Error>) -> Void
        ) {
            
            guard let uid = Auth.auth().currentUser?.uid else {
                DispatchQueue.main.async {
                    self.currentUser = nil
                }
                return completion(.success(nil))
            }
            
            DispatchQueue.main.async {
                if let user = holder.fetchUser(byId: uid, context) {
                    self.currentUser = user
                    completion(.success(user))
                } else {
                    completion(.success(nil))
                }
            }
        }
        
        
        func updateProfile(
            firstName: String,
            lastName: String,
            holder: BooklyHolder,
            context: NSManagedObjectContext,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            
            guard let currentUser else {
                return completion(.failure(SimpleError("No current user")))
            }
            
            DispatchQueue.main.async {
                
                do {
                    
                    holder.updateUser(
                        user: currentUser,
                        firstName: firstName,
                        lastName: lastName,
                        context
                    )
                    
                    try context.save()
                    
                    completion(.success(()))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        
        func signOut(
            holder: BooklyHolder,
            context: NSManagedObjectContext
        ) -> Result<Void, Error> {
            
            do {
                
                try Auth.auth().signOut()
                
                DispatchQueue.main.async {
                    
                    self.currentUser?.isActive = false
                    
                    do {
                        try context.save()
                    } catch {
                        print("CoreData save error \(error)")
                    }
                    
                    self.currentUser = nil
                }
                
                return .success(())
                
            } catch {
                
                print("Sign out error: \(error.localizedDescription)")
                return .failure(error)
            }
        }
    }
