//
//  Hotel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation


// Temp Model

struct Hotel: Identifiable {
    let id: UUID = UUID()
    let name: String
    let city: String
    let pricePerNight: Int
    let rating: Double
}
