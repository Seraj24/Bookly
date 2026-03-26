//
//  CoreDataSeedModels.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation

struct DestinationSeed: Codable {
    let id: UUID
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
}

struct AirlineSeed: Codable {
    let id: UUID
    let airlineName: String
}

struct AirportSeed: Codable {
    let id: UUID
    let name: String
    let code: String
    let destinationId: UUID
    let latitude: Double
    let longitude: Double
}

struct HotelSeed: Codable {
    let id: UUID
    let name: String
    let hotelAddress: String
    let hotelDescription: String
    let rating: Double
    let destinationId: UUID
    let latitude: Double
    let longitude: Double
    let photoURL: String
}

struct RoomSeed: Codable {
    let id: UUID
    let roomType: String
    let price: Double
    let quantity: Int32
    let hotelId: UUID
}

struct FlightSeed: Codable {
    let id: UUID
    let flightNumber: String
    let departureTime: Date
    let arrivalTime: Date
    let duration: Double
    let departureAirportId: UUID
    let arrivalAirportId: UUID
    let airlineId: UUID
}

struct CabinSeed: Codable {
    let id: UUID
    let cabinClass: String
    let price: Double
    let remainingSeats: Int16
    let flightId: UUID
}
