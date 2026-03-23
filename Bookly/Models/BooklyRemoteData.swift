//
//  BooklyRemoteData.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation

struct BooklyRemoteData {
    let destinations: [DestinationDocument]
    let airlines: [AirlineDocument]
    let airports: [AirportDocument]
    let hotels: [HotelDocument]
    let rooms: [RoomDocument]
    let flights: [FlightDocument]
    let cabins: [CabinDocument]

    var isEmpty: Bool {
        destinations.isEmpty &&
        airlines.isEmpty &&
        airports.isEmpty &&
        hotels.isEmpty &&
        rooms.isEmpty &&
        flights.isEmpty &&
        cabins.isEmpty
    }
}
