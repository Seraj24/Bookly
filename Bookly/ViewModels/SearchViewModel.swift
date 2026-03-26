//
//  SearchViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import Foundation
import Combine

enum SearchRoute: Hashable, Identifiable {
    case hotelSearch
    case flightSearch
    case mapSearch
    case hotelResults(request: HotelSearchRequest)
    case flightResults(request: FlightSearchRequest)
    case hotelDetails(hotel: Hotel, request: HotelSearchRequest)
    
    var id: Self { self }
}

final class SearchViewModel: ObservableObject {
    @Published var route: SearchRoute?
    
    func openHotelSearch() {
        route = .hotelSearch
    }
    
    func openFlightSearch() {
        route = .flightSearch
    }
    
    func openMapSearch() {
        route = .mapSearch
    }
    
    func showHotelResults(request: HotelSearchRequest) {
        route = .hotelResults(request: request)
    }
    
    func showFlightResults(request: FlightSearchRequest) {
        route = .flightResults(request: request)
    }
    
    func showHotelDetails(_ hotel: Hotel, checkInDate: Date, checkOutDate: Date) {
        let request = HotelSearchRequest(
            destination: hotel.destination?.city ?? "",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate
        )
        
        route = .hotelDetails(hotel: hotel, request: request)
    }
    
    func showHotelsFromMap(
        destination: Destination,
        checkInDate: Date,
        checkOutDate: Date
    ) {
        let request = HotelSearchRequest(
            destination: destination.city ?? "",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate
        )
        
        showHotelResults(request: request)
    }
    
    func showFlightsFromMap(
        departureAirport: Airport,
        arrivalAirport: Airport
    ) {
        let request = FlightSearchRequest(
            fromCity: formattedAirportText(for: departureAirport),
            toCity: formattedAirportText(for: arrivalAirport),
            departureDate: Date(),
            returnDate: nil,
            tripType: .oneWay
        )
        
        showFlightResults(request: request)
    }
    
    private func formattedAirportText(for airport: Airport) -> String {
        let name = airport.name ?? ""
        let code = airport.code ?? ""
        
        if !name.isEmpty && !code.isEmpty {
            return "\(name) (\(code))"
        }
        
        if !code.isEmpty {
            return code
        }
        
        if !name.isEmpty {
            return name
        }
        
        return airport.destination?.city ?? ""
    }
}
