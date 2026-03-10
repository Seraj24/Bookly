//
//  FlightDetailsViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import Foundation
import Combine

final class FlightDetailsViewModel: ObservableObject {
    
    let flight: Flight
    
    init(flight: Flight) {
        self.flight = flight
    }
    
    var airlineText: String {
        flight.airline?.airlineName ?? "Unknown Airline"
    }
    
    var cabinText: String {
        cheapestCabin?.cabinClass ?? "Cabin not available"
    }
    
    var priceText: String {
        guard let cabin = cheapestCabin else { return "N/A" }
        return String(format: "$%.0f", cabin.price)
    }
    
    var departureTimeText: String {
        formatTime(flight.departureTime)
    }
    
    var arrivalTimeText: String {
        formatTime(flight.arrivalTime)
    }
    
    var fromCityText: String {
        airportCodeOrName(flight.departureAirport)
    }
    
    var toCityText: String {
        airportCodeOrName(flight.arrivalAirport)
    }
    
    var durationText: String {
        let totalMinutes = Int(flight.duration) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    var stopsText: String {
        "Flight"
    }
    
    var dateText: String {
        guard let departureTime = flight.departureTime else { return "Unknown date" }
        return departureTime.formatted(date: .abbreviated, time: .omitted)
    }
    
    var descriptionText: String {
        "A clean and comfortable option for your trip."
    }
    
    private var cheapestCabin: Cabin? {
        let cabinsSet = flight.cabins as? Set<Cabin> ?? []
        return cabinsSet.sorted { $0.price < $1.price }.first
    }
    
    private func formatTime(_ date: Date?) -> String {
        guard let date else { return "--:--" }
        return date.formatted(date: .omitted, time: .shortened)
    }
    
    private func airportCodeOrName(_ airport: Airport?) -> String {
        guard let airport else { return "Unknown airport" }
        
        let code = airport.code ?? ""
        let name = airport.name ?? "Unknown airport"
        
        return code.isEmpty ? name : code
    }
}
