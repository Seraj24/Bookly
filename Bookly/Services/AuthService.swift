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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let firebaseUser = result?.user else {
                DispatchQueue.main.async {
                    completion(.failure(SimpleError("No user found after sign in.")))
                }
                return
            }
            
            let uid = firebaseUser.uid
            let fallbackEmail = firebaseUser.email ?? email
            
            Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument { snapshot, error in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        return
                    }
                    
                    let data = snapshot?.data()
                    
                    let firstName = (data?["firstName"] as? String)?
                        .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    
                    let lastName = (data?["lastName"] as? String)?
                        .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    
                    let safeEmail = ((data?["email"] as? String) ?? fallbackEmail)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .lowercased()
                    
                    DispatchQueue.main.async {
                        let appUser: AppUser
                        
                        if let existingUser = holder.fetchUser(byId: uid, context) {
                            existingUser.firstName = firstName
                            existingUser.lastName = lastName
                            existingUser.email = safeEmail
                            existingUser.isActive = true
                            
                            holder.saveContext(context)
                            appUser = existingUser
                        } else {
                            appUser = holder.createUser(
                                id: uid,
                                firstName: firstName,
                                lastName: lastName,
                                email: safeEmail,
                                isActive: true,
                                context
                            )
                        }
                        
                        self.isGuest = false
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
    
    func createHotelBooking(
        _ booking: HotelBooking,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let data: [String: Any] = [
            "id": booking.id,
            "userId": booking.userId,
            "hotelId": booking.hotelId?.uuidString as Any,
            "hotelName": booking.hotelName,
            "city": booking.city,
            "roomType": booking.roomType,
            "roomPrice": booking.roomPrice,
            "quantity": booking.quantity,
            "checkInDate": Timestamp(date: booking.checkInDate),
            "checkOutDate": Timestamp(date: booking.checkOutDate),
            "guestFirstName": booking.guestFirstName,
            "guestLastName": booking.guestLastName,
            "email": booking.email,
            "phoneNumber": booking.phoneNumber,
            "subtotal": booking.subtotal,
            "taxes": booking.taxes,
            "total": booking.total,
            "status": booking.status.rawValue,
            "createdAt": Timestamp(date: booking.createdAt)
        ]
        
        Firestore.firestore()
            .collection("users")
            .document(booking.userId)
            .collection("hotelBookings")
            .document(booking.id)
            .setData(data) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
    
    func createFlightBooking(
        _ booking: FlightBooking,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let data: [String: Any] = [
            "id": booking.id,
            "userId": booking.userId,
            "flightId": booking.flightId?.uuidString as Any,
            "airlineName": booking.airlineName,
            "departureCode": booking.departureCode,
            "arrivalCode": booking.arrivalCode,
            "departureTime": booking.departureTime.map { Timestamp(date: $0) } as Any,
            "arrivalTime": booking.arrivalTime.map { Timestamp(date: $0) } as Any,
            "cabinClass": booking.cabinClass,
            "cabinPrice": booking.cabinPrice,
            "passengerCount": booking.passengerCount,
            "guestFirstName": booking.guestFirstName,
            "guestLastName": booking.guestLastName,
            "email": booking.email,
            "phoneNumber": booking.phoneNumber,
            "subtotal": booking.subtotal,
            "taxes": booking.taxes,
            "total": booking.total,
            "status": booking.status.rawValue,
            "createdAt": Timestamp(date: booking.createdAt)
        ]
        
        Firestore.firestore()
            .collection("users")
            .document(booking.userId)
            .collection("flightBookings")
            .document(booking.id)
            .setData(data) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
    
    func fetchHotelBookings(
        completion: @escaping (Result<[HotelBooking], Error>) -> Void
    ) {
        guard let userId = currentUser?.id else {
            completion(.failure(SimpleError("No current user")))
            return
        }
        
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("hotelBookings")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        completion(.success([]))
                        return
                    }
                    
                    let bookings: [HotelBooking] = documents.compactMap { document in
                        let data = document.data()
                        
                        guard
                            let id = data["id"] as? String,
                            let userId = data["userId"] as? String,
                            let hotelName = data["hotelName"] as? String,
                            let city = data["city"] as? String,
                            let roomType = data["roomType"] as? String,
                            let roomPrice = data["roomPrice"] as? Double,
                            let quantity = data["quantity"] as? Int,
                            let checkInDate = (data["checkInDate"] as? Timestamp)?.dateValue(),
                            let checkOutDate = (data["checkOutDate"] as? Timestamp)?.dateValue(),
                            let guestFirstName = data["guestFirstName"] as? String,
                            let guestLastName = data["guestLastName"] as? String,
                            let email = data["email"] as? String,
                            let phoneNumber = data["phoneNumber"] as? String,
                            let subtotal = data["subtotal"] as? Double,
                            let taxes = data["taxes"] as? Double,
                            let total = data["total"] as? Double,
                            let statusRaw = data["status"] as? String,
                            let status = BookingStatus(rawValue: statusRaw),
                            let createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
                        else {
                            return nil
                        }
                        
                        let hotelIdString = data["hotelId"] as? String
                        let hotelId = hotelIdString.flatMap(UUID.init(uuidString:))
                        
                        return HotelBooking(
                            id: id,
                            userId: userId,
                            hotelId: hotelId,
                            hotelName: hotelName,
                            city: city,
                            roomType: roomType,
                            roomPrice: roomPrice,
                            quantity: quantity,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            guestFirstName: guestFirstName,
                            guestLastName: guestLastName,
                            email: email,
                            phoneNumber: phoneNumber,
                            subtotal: subtotal,
                            taxes: taxes,
                            total: total,
                            status: status,
                            createdAt: createdAt
                        )
                    }
                    
                    completion(.success(bookings))
                }
            }
        
    }
    
    func fetchFlightBookings(
        completion: @escaping (Result<[FlightBooking], Error>) -> Void
    ) {
        guard let userId = currentUser?.id else {
            completion(.failure(SimpleError("No current user")))
            return
        }
        
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("flightBookings")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        completion(.success([]))
                        return
                    }
                    
                    let bookings: [FlightBooking] = documents.compactMap { document in
                        let data = document.data()
                        
                        guard
                            let id = data["id"] as? String,
                            let userId = data["userId"] as? String,
                            let airlineName = data["airlineName"] as? String,
                            let departureCode = data["departureCode"] as? String,
                            let arrivalCode = data["arrivalCode"] as? String,
                            let cabinClass = data["cabinClass"] as? String,
                            let cabinPrice = data["cabinPrice"] as? Double,
                            let passengerCount = data["passengerCount"] as? Int,
                            let guestFirstName = data["guestFirstName"] as? String,
                            let guestLastName = data["guestLastName"] as? String,
                            let email = data["email"] as? String,
                            let phoneNumber = data["phoneNumber"] as? String,
                            let subtotal = data["subtotal"] as? Double,
                            let taxes = data["taxes"] as? Double,
                            let total = data["total"] as? Double,
                            let statusRaw = data["status"] as? String,
                            let status = BookingStatus(rawValue: statusRaw),
                            let createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
                        else {
                            return nil
                        }
                        
                        let flightIdString = data["flightId"] as? String
                        let flightId = flightIdString.flatMap(UUID.init(uuidString:))
                        let departureTime = (data["departureTime"] as? Timestamp)?.dateValue()
                        let arrivalTime = (data["arrivalTime"] as? Timestamp)?.dateValue()
                        
                        return FlightBooking(
                            id: id,
                            userId: userId,
                            flightId: flightId,
                            airlineName: airlineName,
                            departureCode: departureCode,
                            arrivalCode: arrivalCode,
                            departureTime: departureTime,
                            arrivalTime: arrivalTime,
                            cabinClass: cabinClass,
                            cabinPrice: cabinPrice,
                            passengerCount: passengerCount,
                            guestFirstName: guestFirstName,
                            guestLastName: guestLastName,
                            email: email,
                            phoneNumber: phoneNumber,
                            subtotal: subtotal,
                            taxes: taxes,
                            total: total,
                            status: status,
                            createdAt: createdAt
                        )
                    }
                    
                    completion(.success(bookings))
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
