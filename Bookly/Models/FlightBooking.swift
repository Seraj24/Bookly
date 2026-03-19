//
//  FlightBooking.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import Foundation

struct FlightBooking: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    let flightId: UUID?
    let airlineName: String
    let departureCode: String
    let arrivalCode: String
    let departureTime: Date?
    let arrivalTime: Date?
    let cabinClass: String
    let cabinPrice: Double
    let passengerCount: Int
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
