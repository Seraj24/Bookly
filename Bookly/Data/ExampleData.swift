//
//  ExampleDeals.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation

enum ExampleHotels {
    static let all: [Hotel] = [
        Hotel(name: "Downtown Hotel", city: "Montreal", pricePerNight: 129, rating: 4.4),
        Hotel(name: "Old Port Boutique", city: "Montreal", pricePerNight: 149, rating: 4.6),
        Hotel(name: "City Lights Inn", city: "Toronto", pricePerNight: 109, rating: 4.2),
        Hotel(name: "Harborview Suites", city: "Toronto", pricePerNight: 179, rating: 4.5),
        Hotel(name: "Ocean Breeze Resort", city: "Miami", pricePerNight: 199, rating: 4.7),
        Hotel(name: "Sunset Beach Hotel", city: "Miami", pricePerNight: 169, rating: 4.3)
    ]
}
enum ExampleDeals {
    static let sample: [Deal] = [
        Deal(
            title: "Downtown Hotel",
            location: "Montreal",
            pricePerNight: 129,
            rating: 4.4
        ),
        Deal(
            title: "Sea View Resort",
            location: "Miami",
            pricePerNight: 199,
            rating: 4.7
        ),
        Deal(
            title: "Cozy City Apartment",
            location: "Toronto",
            pricePerNight: 109,
            rating: 4.2
        )
    ]
}


