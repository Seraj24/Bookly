//
//  FlightSearchRequest.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import Foundation

struct FlightSearchRequest: Hashable {
    let fromCity: String
    let toCity: String
    let departureDate: Date
    let returnDate: Date?
    let tripType: TripType
}
