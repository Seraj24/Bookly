//
//  FlightBookingViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import Foundation
import Combine

final class FlightBookingViewModel: ObservableObject {
    
    let selection: FlightBookingSelection
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    init(selection: FlightBookingSelection) {
        self.selection = selection
    }
    
    var airlineText: String {
        selection.flight.airline?.airlineName ?? "Unknown Airline"
    }
    
    var cabinText: String {
        selection.cabin.cabinClass ?? "Unknown Cabin"
    }
    
    var fromText: String {
        airportDisplayName(selection.flight.departureAirport)
    }
    
    var toText: String {
        airportDisplayName(selection.flight.arrivalAirport)
    }
    
    var departureTimeText: String {
        formatTime(selection.flight.departureTime)
    }
    
    var arrivalTimeText: String {
        formatTime(selection.flight.arrivalTime)
    }
    
    var dateText: String {
        guard let departureTime = selection.flight.departureTime else {
            return "Unknown date"
        }
        return departureTime.formatted(date: .abbreviated, time: .omitted)
    }
    
    var durationText: String {
        let totalMinutes = Int(selection.flight.duration) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    var passengerCountText: String {
        "\(selection.passengerCount)"
    }
    
    var pricePerPassenger: Double {
        selection.cabin.price
    }
    
    var subtotal: Double {
        pricePerPassenger * Double(selection.passengerCount)
    }
    
    var taxesAndFees: Double {
        subtotal * 0.18
    }
    
    var total: Double {
        subtotal + taxesAndFees
    }
    
    var pricePerPassengerText: String {
        String(format: "$%.0f", pricePerPassenger)
    }
    
    var subtotalText: String {
        String(format: "$%.0f", subtotal)
    }
    
    var taxesAndFeesText: String {
        String(format: "$%.0f", taxesAndFees)
    }
    
    var totalText: String {
        String(format: "$%.0f", total)
    }
    
    var canConfirm: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
