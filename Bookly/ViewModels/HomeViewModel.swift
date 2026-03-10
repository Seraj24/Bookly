//
//  HomeViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine

enum TripType: String, CaseIterable {
    case oneWay = "One-way"
    case roundTrip = "Round trip"
}

final class HomeViewModel: ObservableObject {
    
    @Published var destination: String = ""
    
    @Published var fromCity: String = ""
    @Published var toCity: String = ""
    
    @Published var date: Date = .now
    
    @Published var tripType: TripType = .roundTrip

    @Published var departureDate: Date? = nil
    @Published var returnDate: Date? = nil
    
    @Published var selectedCategory: Category = .hotels
    
    @Published var hotelGuests: Int = 1
    @Published var flightPassengers: Int = 1
    
    @Published var route: HomeRoute? = nil
    

    var departureDateText: String {
            departureDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select"
        }

    var returnDateText: String {
        returnDate?.formatted(date: .abbreviated, time: .omitted) ?? "Select"
        
    }
    
    // Data (temporary)
    @Published private(set) var deals: [Deal] = ExampleDeals.sample
    
    let locations: [String] = [
            "Montreal", "Toronto", "Vancouver", "New York",
            "Miami", "Los Angeles", "Paris", "London", "Dubai"
    ]
    
    let airports: [String] = [
        "Montréal–Trudeau International Airport (YUL)",
        "Toronto Pearson International Airport (YYZ)",
        "Vancouver International Airport (YVR)",
        "John F. Kennedy International Airport (JFK)",
        "Miami International Airport (MIA)",
        "Los Angeles International Airport (LAX)",
        "Paris Charles de Gaulle Airport (CDG)",
        "London Heathrow Airport (LHR)",
        "Dubai International Airport (DXB)"
    ]
    
    var destinationSuggestions: [String] {
        
        let trimmedDestination = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        let loweredDestination = trimmedDestination.lowercased()
        
        guard !loweredDestination.isEmpty else { return Array(locations.prefix(6)) }
        
        return locations
            .filter { $0.lowercased().hasPrefix(loweredDestination)
        }
    }
    
    var airportsSuggestionsFrom: [String] {
        let trimmedAirport = fromCity.trimmingCharacters(in: .whitespacesAndNewlines)
        let loweredAirport = trimmedAirport.lowercased()
        
        guard !loweredAirport.isEmpty else { return Array(airports.prefix(6)) }
        
        return airports
            .filter { $0.lowercased().hasPrefix(loweredAirport)
            }
    }
    
    var airportsSuggestionsTo: [String] {
        let trimmedAirport = toCity.trimmingCharacters(in: .whitespacesAndNewlines)
        let loweredAirport = trimmedAirport.lowercased()
        
        guard !loweredAirport.isEmpty else { return Array(airports.prefix(6)) }
        
        return airports
            .filter { $0.lowercased().hasPrefix(loweredAirport)
            }
    }
    var canSearchHotels: Bool {
        !destination.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var canSearchFlights: Bool {
        let departureOk =
        !fromCity.trimmingCharacters(in: .whitespaces).isEmpty &&
        airports.contains { $0.lowercased() == fromCity.lowercased() }
        
        let arrivalOk =
        !toCity.trimmingCharacters(in: .whitespaces).isEmpty &&
        airports.contains { $0.lowercased() == toCity.lowercased() }
        
        let dateOk = departureDate != nil
        let returnOK = (tripType == .oneWay) || (returnDate != nil)
        

        let orderOK: Bool = {
            guard tripType == .roundTrip,
                  let d = departureDate,
                  let r = returnDate else { return true }
            return r >= d
        }()
        
        return departureOk && arrivalOk && dateOk && returnOK && orderOK
        
    }
    
    func normalizeFlightDatesIfNeeded() {
        guard tripType == .roundTrip,
              let d = departureDate,
              let r = returnDate else { return }
        if r < d { returnDate = d }
    }
    
    func searchTapped() {
        switch selectedCategory {
            
            case .hotels:
            guard canSearchHotels else { return }
                let dest = destination.trimmingCharacters(in: .whitespacesAndNewlines)
                route = .hotels(destination: dest)
            case .flights:
            guard canSearchFlights else { return }
                var flightSearchRequest: FlightSearchRequest {
                    FlightSearchRequest(
                        fromCity: fromCity,
                        toCity: toCity,
                        departureDate: departureDate ?? .now,
                        returnDate: returnDate,
                        tripType: tripType
                    )
                }
                route = .flights(request: flightSearchRequest)
            break

        }
    }
        
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func clearSearchFields() {
        destination = ""
        fromCity = ""
        toCity = ""
    }
}
    
    
