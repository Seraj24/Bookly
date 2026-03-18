//
//  FlightRowViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/18/26.
//

import Foundation
import Combine

final class FlightRowViewModel: ObservableObject {
    
    let flight: Flight
    
    init(flight: Flight) {
        self.flight = flight
    }
    
    var airlineText: String {
        flight.airline?.airlineName ?? "Unknown Airline"
    }
    
    var departureTimeText: String {
        formatTime(flight.departureTime)
    }
    
    var arrivalTimeText: String {
        formatTime(flight.arrivalTime)
    }
    
    var departureAirportText: String {
        airportDisplayName(flight.departureAirport)
    }
    
    var arrivalAirportText: String {
        airportDisplayName(flight.arrivalAirport)
    }
    
    var durationText: String {
        let totalMinutes = Int(flight.duration) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    var dateText: String {
        guard let departureTime = flight.departureTime else { return "Unknown date" }
        return departureTime.formatted(date: .abbreviated, time: .omitted)
    }
    
    var cabins: [Cabin] {
        let cabinsSet = flight.cabins as? Set<Cabin> ?? []
        return cabinsSet.sorted { $0.price < $1.price }
    }
    
    func cabinClassText(for cabin: Cabin) -> String {
        let value = cabin.cabinClass?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return value.isEmpty ? "Unknown Cabin" : value
    }
    
    func cabinPriceText(for cabin: Cabin) -> String {
        String(format: "$%.0f", cabin.price)
    }
    
    func cabinSeatsText(for cabin: Cabin) -> String {
        "\(cabin.remainingSeats) seats left"
    }
    
    private func formatTime(_ date: Date?) -> String {
        guard let date else { return "--:--" }
        return date.formatted(date: .omitted, time: .shortened)
    }
    
    private func airportDisplayName(_ airport: Airport?) -> String {
        guard let airport else { return "Unknown airport" }
        
        let code = airport.code ?? ""
        let name = airport.name ?? "Unknown airport"
        
        return code.isEmpty ? name : code
    }
}
