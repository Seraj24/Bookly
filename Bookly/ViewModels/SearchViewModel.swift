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
    case mapSearch(mode: DestinationBrowseMode)
    case hotelResults(request: HotelSearchRequest)
    case flightResults(request: FlightSearchRequest)
    case hotelDetails(hotel: Hotel, request: HotelSearchRequest)
    
    var id: Self { self }
}

final class SearchViewModel: ObservableObject {
    @Published var route: SearchRoute?
    
    @Published var selectedFromAirportText: String?
    @Published var selectedToAirportText: String?
    
    func openHotelSearch() {
        route = .hotelSearch
    }
    
    func openFlightSearch() {
        route = .flightSearch
    }
    
    func openMapSearch(mode: DestinationBrowseMode = .hotel) {
        route = .mapSearch(mode: mode)
    }
    
    func showHotelResults(request: HotelSearchRequest) {
        route = .hotelResults(request: request)
    }
    
    func showFlightResults(request: FlightSearchRequest) {
        route = .flightResults(request: request)
    }
    
    func showHotelDetails(_ hotel: Hotel) {
        let request = HotelSearchRequest(
            destination: hotel.destination?.city ?? "",
            checkInDate: Date(),
            checkOutDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        )
        
        route = .hotelDetails(hotel: hotel, request: request)
    }
    
    func handleMapPrimaryAction(
        destination: Destination,
        contentType: DestinationBrowseContentType,
        mode: DestinationBrowseMode
    ) {
        switch contentType {
        case .hotels:
            let request = HotelSearchRequest(
                destination: destination.city ?? "",
                checkInDate: Date(),
                checkOutDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            )
            
            showHotelResults(request: request)
            
        case .airports:
            switch mode {
            case .hotel:
                break
                
            case .from:
                route = .mapSearch(mode: .to)
                
            case .to:
                if let fromCity = selectedFromAirportText {
                    let request = FlightSearchRequest(
                        fromCity: fromCity,
                        toCity: destination.city ?? "",
                        departureDate: Date(),
                        returnDate: nil,
                        tripType: .oneWay
                    )
                    
                    showFlightResults(request: request)
                }
            }
        }
    }
    
    func handleAirportPicked(
        airport: Airport,
        mode: DestinationBrowseMode
    ) {
        let airportText = formattedAirportText(for: airport)
        
        switch mode {
        case .hotel:
            break
            
        case .from:
            selectedFromAirportText = airportText
            route = .mapSearch(mode: .to)
            
        case .to:
            selectedToAirportText = airportText
            
            guard let fromCity = selectedFromAirportText else { return }
            
            let request = FlightSearchRequest(
                fromCity: fromCity,
                toCity: airportText,
                departureDate: Date(),
                returnDate: nil,
                tripType: .oneWay
            )
            
            showFlightResults(request: request)
        }
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
