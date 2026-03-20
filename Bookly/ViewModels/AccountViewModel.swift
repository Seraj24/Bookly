//
//  AccountViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine
import CoreData

final class AccountViewModel: ObservableObject {
    
    private let auth = AuthService.shared
    private var holder: BooklyHolder?
    private var context: NSManagedObjectContext?
    
    @Published var appUser: AppUser?
    @Published var hotelBookings: [HotelBooking] = []
    @Published var flightBookings: [FlightBooking] = []
    @Published var isLoadingBookings = false
    @Published var bookingErrorMessage: String?
    
    init() {
        self.appUser = auth.currentUser
    }
    
    func configure(holder: BooklyHolder, context: NSManagedObjectContext) {
        self.holder = holder
        self.context = context
    }
    
    var isSignedIn: Bool {
        appUser != nil
    }
    
    var fullName: String {
        let first = appUser?.firstName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let last = appUser?.lastName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let combined = "\(first) \(last)".trimmingCharacters(in: .whitespacesAndNewlines)
        return combined.isEmpty ? "Traveler" : combined
    }
    
    var emailText: String {
        appUser?.email ?? "No email available"
    }
    
    var totalBookingsCount: Int {
        hotelBookings.count + flightBookings.count
    }
    
    func refreshUser() {
        appUser = auth.currentUser
    }
    
    func loadBookings() {
        guard appUser != nil else {
            hotelBookings = []
            flightBookings = []
            bookingErrorMessage = nil
            return
        }
        
        isLoadingBookings = true
        bookingErrorMessage = nil
        
        let group = DispatchGroup()
        var hotelResult: Result<[HotelBooking], Error>?
        var flightResult: Result<[FlightBooking], Error>?
        
        group.enter()
        auth.fetchHotelBookings { result in
            hotelResult = result
            group.leave()
        }
        
        group.enter()
        auth.fetchFlightBookings { result in
            flightResult = result
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.isLoadingBookings = false
            
            switch hotelResult {
            case .success(let bookings):
                self.hotelBookings = bookings
            case .failure(let error):
                self.hotelBookings = []
                self.bookingErrorMessage = error.localizedDescription
            case .none:
                self.hotelBookings = []
            }
            
            switch flightResult {
            case .success(let bookings):
                self.flightBookings = bookings
            case .failure(let error):
                self.flightBookings = []
                self.bookingErrorMessage = self.bookingErrorMessage ?? error.localizedDescription
            case .none:
                self.flightBookings = []
            }
        }
    }
    
    func logOut() {
        guard let holder, let context else { return }
        
        let result = auth.signOut(holder: holder, context: context)
        
        switch result {
        case .success:
            appUser = nil
            hotelBookings = []
            flightBookings = []
            bookingErrorMessage = nil
        case .failure(let error):
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}

