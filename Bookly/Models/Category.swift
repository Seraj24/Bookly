//
//  Category.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation

// Temp Model
enum Category: String, CaseIterable, Identifiable {
    case hotels
    case flights

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .hotels:
            return "Hotels"
        case .flights:
            return "Flights"
        }
    }

    var icon: String {
        switch self {
        case .hotels:
            return "bed.double"
        case .flights:
            return "airplane"
        }
    }
}
