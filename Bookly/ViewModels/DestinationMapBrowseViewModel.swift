//
//  DestinationMapBrowseViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/24/26.
//

import Foundation
import Combine
import MapKit
import CoreLocation
import SwiftUI

enum DestinationBrowseContentType: String, CaseIterable, Identifiable {
    case hotels = "Hotels"
    case airports = "Airports"
    
    var id: String { rawValue }
}

enum FlightSelectionStep: String, CaseIterable, Identifiable {
    case departure = "Departure"
    case arrival = "Arrival"
    
    var id: String { rawValue }
}

final class DestinationMapBrowseViewModel: ObservableObject {
    
    @Published var camera: MapCameraPosition = .automatic
    @Published var zoomLevel: Double = 2_000_000
    @Published var searchText: String = ""
    @Published var selectedDestination: Destination?
    @Published var didAutoCenter: Bool = false
    @Published var selectedContentType: DestinationBrowseContentType = .hotels
    
    @Published var checkInDate: Date = Date()
    @Published var checkOutDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    @Published var flightSelectionStep: FlightSelectionStep = .departure
    @Published var selectedDepartureAirport: Airport?
    @Published var selectedArrivalAirport: Airport?
    
    var navigationTitle: String {
        "Browse Map"
    }
    
    var searchPlaceholder: String {
        "Search destinations..."
    }
    
    var primaryActionTitle: String {
        switch selectedContentType {
        case .hotels:
            return "Show Hotels"
        case .airports:
            return "Show Flights"
        }
    }
    
    var flightSelectionPrompt: String {
        switch (selectedDepartureAirport, selectedArrivalAirport, flightSelectionStep) {
        case (nil, nil, .departure):
            return "Choose a departure airport."
        case (_, nil, .arrival):
            return "Choose an arrival airport."
        case (nil, _, .departure):
            return "Choose a departure airport."
        case let (departure?, nil, _):
            return "Departure selected: \(airportDisplayText(departure)). Now choose an arrival airport."
        case let (nil, arrival?, _):
            return "Arrival selected: \(airportDisplayText(arrival)). Now choose a departure airport."
        case let (departure?, arrival?, _):
            return "Departure: \(airportDisplayText(departure)) • Arrival: \(airportDisplayText(arrival))"
        }
    }
    
    var canShowFlights: Bool {
        selectedDepartureAirport != nil && selectedArrivalAirport != nil
    }
    
    func filteredDestinations(from destinations: [Destination]) -> [Destination] {
        let query = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        guard !query.isEmpty else {
            return destinations
        }
        
        return destinations.filter { destination in
            let city = destination.city?.lowercased() ?? ""
            let country = destination.country?.lowercased() ?? ""
            return city.contains(query) || country.contains(query)
        }
    }
    
    func setupInitialCamera(userLocation: CLLocationCoordinate2D?) {
        guard !didAutoCenter else { return }
        didAutoCenter = true
        
        let fallbackCoordinate = CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673)
        let center = userLocation ?? fallbackCoordinate
        
        updateCamera(center: center, distance: zoomLevel)
    }
    
    func goToUserLocation(_ userLocation: CLLocationCoordinate2D?) {
        guard let userLocation else { return }
        updateCamera(center: userLocation, distance: zoomLevel)
    }
    
    func zoomIn(center: CLLocationCoordinate2D?) {
        guard let center else { return }
        zoomLevel *= 0.8
        updateCamera(center: center, distance: zoomLevel)
    }
    
    func zoomOut(center: CLLocationCoordinate2D?) {
        guard let center else { return }
        zoomLevel *= 1.2
        updateCamera(center: center, distance: zoomLevel)
    }
    
    func selectDestination(_ destination: Destination) {
        selectedDestination = destination
    }
    
    func focusOnCoordinate(_ coordinate: CLLocationCoordinate2D, distance: Double = 120_000) {
        zoomLevel = distance
        updateCamera(center: coordinate, distance: distance)
    }
    
    func destinationCoordinate(for destination: Destination) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: destination.latitude,
            longitude: destination.longitude
        )
    }
    
    func getHotels(for destination: Destination, from hotels: [Hotel]) -> [Hotel] {
        hotels.filter { $0.destination == destination }
    }
    
    func getAirports(for destination: Destination, from airports: [Airport]) -> [Airport] {
        airports.filter { $0.destination == destination }
    }
    
    func visibleHotels(from allHotels: [Hotel]) -> [Hotel] {
        guard let selectedDestination else { return [] }
        return getHotels(for: selectedDestination, from: allHotels)
    }
    
    func visibleAirports(from allAirports: [Airport]) -> [Airport] {
        guard let selectedDestination else { return [] }
        return getAirports(for: selectedDestination, from: allAirports)
    }
    
    func selectAirport(_ airport: Airport) {
        switch flightSelectionStep {
        case .departure:
            selectedDepartureAirport = airport
            if selectedArrivalAirport == nil {
                flightSelectionStep = .arrival
            }
            
        case .arrival:
            selectedArrivalAirport = airport
            if selectedDepartureAirport == nil {
                flightSelectionStep = .departure
            }
        }
    }
    
    func chooseDepartureStep() {
        flightSelectionStep = .departure
    }
    
    func chooseArrivalStep() {
        flightSelectionStep = .arrival
    }
    
    func normalizeDatesIfNeeded() {
        if checkOutDate < checkInDate {
            checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDate) ?? checkInDate
        }
    }
    
    func airportDisplayText(_ airport: Airport) -> String {
        let name = airport.name ?? ""
        let code = airport.code ?? ""
        
        if !name.isEmpty && !code.isEmpty {
            return "\(name) (\(code))"
        }
        
        if !code.isEmpty {
            return code
        }
        
        return name.isEmpty ? "Unknown Airport" : name
    }
    
    private func updateCamera(center: CLLocationCoordinate2D, distance: Double) {
        camera = .camera(
            MapCamera(
                centerCoordinate: center,
                distance: distance
            )
        )
    }
}
