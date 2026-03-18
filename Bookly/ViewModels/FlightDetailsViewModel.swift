//
//  FlightDetailsViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import Foundation
import Combine
import CoreData

final class FlightDetailsViewModel: ObservableObject {
    
    private let flight: Flight
    private var holder: BooklyHolder?
    private var context: NSManagedObjectContext?
    
    @Published var cabins: [Cabin] = []
    @Published var selectedCabin: Cabin?
    @Published var selectedSeatCount: Int = 1
    
    init(flight: Flight) {
        self.flight = flight
    }
    
    func configure(holder: BooklyHolder, context: NSManagedObjectContext) {
        self.holder = holder
        self.context = context
        loadCabins()
    }
    
    func loadCabins() {
        guard let holder, let context else { return }
        cabins = holder.fetchCabins(for: flight, context)
        
        if selectedCabin == nil {
            selectedCabin = cabins.first
        }
        
        if let selectedCabin, selectedSeatCount > Int(selectedCabin.remainingSeats) {
            selectedSeatCount = Int(selectedCabin.remainingSeats)
        }
    }
    
    var airlineText: String {
        flight.airline?.airlineName ?? "Unknown Airline"
    }
    
    var cabinText: String {
        selectedCabin?.cabinClass ?? "Cabin not available"
    }
    
    var priceText: String {
        guard let cabin = selectedCabin else { return "N/A" }
        return String(format: "$%.0f", cabin.price)
    }
    
    var totalPriceText: String {
        guard let cabin = selectedCabin else { return "N/A" }
        let total = cabin.price * Double(selectedSeatCount)
        return String(format: "$%.0f", total)
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
        "Direct"
    }
    
    var dateText: String {
        guard let departureTime = flight.departureTime else { return "Unknown date" }
        return departureTime.formatted(date: .abbreviated, time: .omitted)
    }
    
    var descriptionText: String {
        "A clean and comfortable option for your trip."
    }
    
    var canBook: Bool {
        selectedCabin != nil
    }
    
    var maxSelectableSeats: Int {
        Int(selectedCabin?.remainingSeats ?? 1)
    }
    
    func selectCabin(_ cabin: Cabin) {
        selectedCabin = cabin
        
        if selectedSeatCount > Int(cabin.remainingSeats) {
            selectedSeatCount = Int(cabin.remainingSeats)
        }
        
        if selectedSeatCount < 1 {
            selectedSeatCount = 1
        }
    }
    
    func isSelected(_ cabin: Cabin) -> Bool {
        selectedCabin?.objectID == cabin.objectID
    }
    
    func increaseSeatCount() {
        guard selectedSeatCount < maxSelectableSeats else { return }
        selectedSeatCount += 1
    }
    
    func decreaseSeatCount() {
        guard selectedSeatCount > 1 else { return }
        selectedSeatCount -= 1
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
