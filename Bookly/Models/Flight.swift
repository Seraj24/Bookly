//
//  Flight.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import Foundation

struct Flight: Identifiable {
    let id = UUID()
    let airline: String
    let fromCity: String
    let toCity: String
    let departureTime: String
    let arrivalTime: String
    let date: String
    let duration: String
    let price: Int
    let cabin: String
    let stopsText: String
}
