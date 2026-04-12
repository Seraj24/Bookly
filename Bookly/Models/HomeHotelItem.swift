//
//  HomeHotelItem.swift
//  Bookly
//
//  Created by user938962 on 4/12/26.
//

import Foundation

struct HomeHotelItem: Identifiable, Hashable {
    let id: UUID
    let hotel: Hotel
    let name: String
    let address: String
    let rating: Float
    let imageURL: URL?
    let destinationTitle: String
}
