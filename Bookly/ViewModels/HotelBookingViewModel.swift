//
//  HotelBookingViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import Foundation
import Combine

final class HotelBookingViewModel: ObservableObject {
    
    let selection: HotelBookingSelection
    
    private var authService = AuthService.shared
    
    @Published var guestFirstName: String = ""
    @Published var guestLastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var checkInDate: Date = Date()
    @Published var checkOutDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    @Published var createdBooking: HotelBooking?
    @Published var bookingErrorMessage: String?
    @Published var isSubmitting = false
    
    init(selection: HotelBookingSelection) {
        self.selection = selection
    }
    
    var hotelName: String {
        selection.hotel.name ?? "Unknown Hotel"
    }
    
    var cityText: String {
        selection.hotel.destination?.city ?? "Unknown City"
    }
    
    var addressText: String {
        selection.hotel.hotelAddress ?? "Address unavailable"
    }
    
    var roomTypeText: String {
        (selection.room.roomType ?? "Unknown Room").capitalized
    }
    
    var quantityText: String {
        "\(selection.quantity)"
    }
    
    var nightsCount: Int {
        let days = Calendar.current.dateComponents([.day], from: checkInDate.startOfDay, to: checkOutDate.startOfDay).day ?? 1
        return max(days, 1)
    }
    
    var pricePerNight: Double {
        selection.room.price ?? 0.0
    }
    
    var subtotal: Double {
        pricePerNight * Double(selection.quantity) * Double(nightsCount)
    }
    
    var taxes: Double {
        subtotal * 0.15
    }
    
    var total: Double {
        subtotal + taxes
    }
    
    var subtotalText: String {
        String(format: "$%.0f", subtotal)
    }
    
    var taxesText: String {
        String(format: "$%.0f", taxes)
    }
    
    var totalText: String {
        String(format: "$%.0f", total)
    }
    
    var canConfirm: Bool {
        !guestFirstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !guestLastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        checkOutDate > checkInDate
    }
    
    func createBooking() {
        guard let userId = authService.currentUser?.id else {
            bookingErrorMessage = "No signed-in user was found."
            return
        }
        
        isSubmitting = true
        bookingErrorMessage = nil
        
        let hotel = selection.hotel
        let room = selection.room
        
        let newBooking = HotelBooking(
            id: UUID().uuidString,
            userId: userId,
            hotelId: hotel.id,
            hotelName: hotel.name ?? "Unknown Hotel",
            city: hotel.destination?.city ?? "Unknown City",
            roomType: room.roomType ?? "Unknown Room",
            roomPrice: room.price,
            quantity: selection.quantity,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guestFirstName: guestFirstName,
            guestLastName: guestLastName,
            email: email,
            phoneNumber: phoneNumber,
            subtotal: subtotal,
            taxes: taxes,
            total: total,
            status: .pending,
            createdAt: Date()
        )
        
        authService.createHotelBooking(newBooking) { result in
            DispatchQueue.main.async {
                self.isSubmitting = false
                
                switch result {
                case .success:
                    self.createdBooking = newBooking
                case .failure(let error):
                    self.bookingErrorMessage = error.localizedDescription
                }
            }
        }
    }
}

private extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
