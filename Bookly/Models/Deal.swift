//
//  Deal.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation

struct Deal: Identifiable {
    let id: UUID = UUID()
    let title: String
    let location: String
    let pricePerNight: Int
    let rating: Double
}
