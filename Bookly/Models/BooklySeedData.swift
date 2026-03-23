//
//  BooklySeedData.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation

struct BooklySeedData: Codable {
    let destinations: [DestinationSeed]
    let airlines: [AirlineSeed]
    let airports: [AirportSeed]
    let hotels: [HotelSeed]
    let rooms: [RoomSeed]
    let flights: [FlightSeed]
    let cabins: [CabinSeed]
}
