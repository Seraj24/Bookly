//
//  HotelBooking.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import Foundation

struct HotelBooking: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let hotelId: UUID?
    let hotelName: String
    let city: String
    let roomType: String
    let roomPrice: Double
    let quantity: Int
    let checkInDate: Date
    let checkOutDate: Date
    let guestFirstName: String
    let guestLastName: String
    let email: String
    let phoneNumber: String
    let subtotal: Double
    let taxes: Double
    let total: Double
    let status: BookingStatus
    let createdAt: Date
}
