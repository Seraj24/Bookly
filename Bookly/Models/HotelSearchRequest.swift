//
//  HotelSearchRequest.swift
//  Bookly
//
//  Created by user938962 on 3/20/26.
//

import Foundation

struct HotelSearchRequest: Hashable {
    let destination: String
    let checkInDate: Date
    let checkOutDate: Date
}
