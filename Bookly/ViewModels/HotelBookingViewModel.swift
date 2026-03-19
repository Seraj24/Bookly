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
    
    @Published var guestFirstName: String = ""
    @Published var guestLastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var checkInDate: Date = Date()
    @Published var checkOutDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
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
}

private extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
