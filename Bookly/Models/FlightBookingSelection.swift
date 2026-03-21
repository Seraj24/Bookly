//
//  FlightBookingSelection.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import Foundation
import CoreData

struct FlightBookingSelection {
    let flight: Flight
    let cabin: Cabin
    let passengerCount: Int
    let departureDate: Date
}
