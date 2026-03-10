//
//  HotelDetailsViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import Foundation
import Combine

final class HotelDetailsViewModel: ObservableObject {

    private let hotel: Hotel

    init(hotel: Hotel) {
        self.hotel = hotel
    }

    var name: String {
        hotel.name
    }

    var city: String {
        hotel.city
    }

    var ratingText: String {
        String(format: "%.1f", hotel.rating)
    }

    var priceText: String {
        "$\(hotel.pricePerNight)/night"
    }

    var shortDescription: String {
        "A comfortable stay in \(hotel.city), ideal for travelers looking for convenience and value."
    }
}
