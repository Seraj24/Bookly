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
    @Published var departureDate: Date = .now
    @Published var returnDate: Date? = nil
    @Published var flightPassengers: Int = 1
    
    private var holder: BooklyHolder?
    private var cachedAirports: [String] = []

    func configure(holder: BooklyHolder) {
        guard self.holder == nil else { return }
        
        self.holder = holder
        self.cachedAirports = holder.airports
            .compactMap { airport in
                let name = (airport.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                let code = (airport.code ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                if !name.isEmpty && !code.isEmpty {
                    return "\(name) (\(code))"
                } else if !name.isEmpty {
                    return name
                } else {
                    return nil
                }
            }
            .sorted()
        
    }

    var airports: [String] {
        cachedAirports
    }

    var airportsSuggestionsFrom: [String] {
        filteredSuggestions(for: fromCity)
        
    }

    var airportsSuggestionsTo: [String] {
        filteredSuggestions(for: toCity)
        
    }

    private func filteredSuggestions(for text: String) -> [String] {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed.isEmpty else {
            return Array(cachedAirports.prefix(6))
        }
        
        let lowercasedQuery = trimmed.lowercased()
        
        return cachedAirports
            .filter { $0.lowercased().hasPrefix(lowercasedQuery) }
            .prefix(6)
            .map { $0 }
        
    }
    
    var departureDateText: String {
        departureDate.formatted(date: .abbreviated, time: .omitted)
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
        
        let returnOk = (tripType == .oneWay) || (returnDate != nil)
        
        let orderOk: Bool = {
            guard tripType == .roundTrip,
                  let r = returnDate else { return true }
            return r >= departureDate
        }()
        
        return departureOk && arrivalOk && returnOk && orderOk
    }
    
    func normalizeFlightDatesIfNeeded() {
        guard tripType == .roundTrip,
              let r = returnDate else { return }
        
        if r < departureDate {
            returnDate = departureDate
        }
    }
    
    func makeRequest() -> FlightSearchRequest? {
        guard canSearchFlights else { return nil }
        
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
        departureDate = .now
        returnDate = nil
        flightPassengers = 1
        tripType = .roundTrip
    }
}
