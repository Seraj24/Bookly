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
        hotel.name ?? "Unknown Hotel"
    }

    var city: String {
        hotel.destination?.city ?? "Unknown City"
    }
    
    var address: String {
        hotel.hotelAddress ?? "Address not available"
    }

    var ratingText: String {
        String(format: "%.1f", hotel.rating)
    }

    var priceText: String {
        if hotel.responds(to: Selector(("pricePerNight"))) {
            return "Price unavailable"
        } else {
            return "Price unavailable"
        }
    }

    var shortDescription: String {
        let description = hotel.hotelDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !description.isEmpty {
            return description
        }
        
        return "A comfortable stay in \(city), ideal for travelers looking for convenience and value."
    }
}
