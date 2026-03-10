//
//  FlightSearchViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import Foundation
import Combine

final class FlightSearchViewModel: ObservableObject {
    @Published var fromCity: String = ""
    @Published var toCity: String = ""
    
    @Published var tripType: TripType = .roundTrip
    @Published var departureDate: Date? = nil
    @Published var returnDate: Date? = nil
    @Published var flightPassengers: Int = 1
    
    private var holder: BooklyHolder?
    
    func configure(holder: BooklyHolder) {
        self.holder = holder
    }
    
    var airports: [String] {
        guard let holder else { return [] }
        
        return holder.airports
            .map { airport in
                let name = airport.name ?? ""
                let code = airport.code ?? ""
                
                if !name.isEmpty && !code.isEmpty {
                    return "\(name) (\(code))"
                } else {
                    return name
                }
            }
            .filter { !$0.isEmpty }
            .sorted()
    }
    
    var airportsSuggestionsFrom: [String] {
        let trimmed = fromCity.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return Array(airports.prefix(6)) }
        return airports.filter { $0.lowercased().hasPrefix(trimmed) }
    }
    
    var airportsSuggestionsTo: [String] {
        let trimmed = toCity.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return Array(airports.prefix(6)) }
        return airports.filter { $0.lowercased().hasPrefix(trimmed) }
    }
    
    var departureDateText: String {
        departureDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select"
    }
    
    var returnDateText: String {
        returnDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select"
    }
    
    var canSearchFlights: Bool {
        let fromTrimmed = fromCity.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let toTrimmed = toCity.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let departureOk =
            !fromTrimmed.isEmpty &&
            airports.contains { $0.lowercased() == fromTrimmed }
        
        let arrivalOk =
            !toTrimmed.isEmpty &&
            airports.contains { $0.lowercased() == toTrimmed }
        
        let dateOk = departureDate != nil
        let returnOk = (tripType == .oneWay) || (returnDate != nil)
        
        let orderOk: Bool = {
            guard tripType == .roundTrip,
                  let d = departureDate,
                  let r = returnDate else { return true }
            return r >= d
        }()
        
        return departureOk && arrivalOk && dateOk && returnOk && orderOk
    }
    
    func normalizeFlightDatesIfNeeded() {
        guard tripType == .roundTrip,
              let d = departureDate,
              let r = returnDate else { return }
        
        if r < d {
            returnDate = d
        }
    }
    
    func makeRequest() -> FlightSearchRequest? {
        guard canSearchFlights, let departureDate else { return nil }
        
        return FlightSearchRequest(
            fromCity: fromCity,
            toCity: toCity,
            departureDate: departureDate,
            returnDate: tripType == .roundTrip ? returnDate : nil,
            tripType: tripType
        )
    }
    
    func clear() {
        fromCity = ""
        toCity = ""
        departureDate = nil
        returnDate = nil
        flightPassengers = 1
        tripType = .roundTrip
    }
}
