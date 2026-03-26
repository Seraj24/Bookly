//
//  FirestoreDocuments.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation

struct DestinationDocument: Codable {
    let id: String
    let city: String
    let country: String
    let latitude: Double?
    let longitude: Double?
}

struct AirlineDocument: Codable {
    let id: String
    let airlineName: String
}

struct AirportDocument: Codable {
    let id: String
    let name: String
    let code: String
    let destinationId: String
    let latitude: Double?
    let longitude: Double?
}

struct HotelDocument: Codable {
    let id: String
    let name: String
    let hotelAddress: String
    let hotelDescription: String
    let rating: Double
    let destinationId: String
    let latitude: Double?
    let longitude: Double?
    let photoURL: String?
}

struct RoomDocument: Codable {
    let id: String
    let roomType: String
    let price: Double
    let quantity: Int32
    let hotelId: String
}

struct FlightDocument: Codable {
    let id: String
    let flightNumber: String
    let departureTime: Date
    let arrivalTime: Date
    let duration: Double
    let fromAirportId: String
    let toAirportId: String
    let airlineId: String
}

struct CabinDocument: Codable {
    let id: String
    let cabinClass: String
    let price: Double
    let remainingSeats: Int16
    let flightId: String
}
