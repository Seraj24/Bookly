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

enum DestinationBrowseMode: String {
   case hotel
   case from
   case to
   
   var title: String {
       switch self {
       case .hotel:
           return "Browse Destinations"
       case .from:
           return "Choose Departure Destination"
       case .to:
           return "Choose Arrival Destination"
       }
   }
   
   var searchPlaceholder: String {
       switch self {
       case .hotel:
           return "Search destinations..."
       case .from:
           return "Search departure destination..."
       case .to:
           return "Search arrival destination..."
       }
   }
}

enum DestinationBrowseContentType: String, CaseIterable, Identifiable {
   case hotels = "Hotels"
   case airports = "Airports"
   
   var id: String { rawValue }
}

final class DestinationMapBrowseViewModel: ObservableObject {
   
   @Published var camera: MapCameraPosition = .automatic
   @Published var zoomLevel: Double = 2_000_000
   @Published var searchText: String = ""
   @Published var selectedDestination: Destination?
   @Published var didAutoCenter: Bool = false
   @Published var selectedContentType: DestinationBrowseContentType
   
   let mode: DestinationBrowseMode
   
   init(mode: DestinationBrowseMode) {
       self.mode = mode
       
       if mode == .hotel {
           self.selectedContentType = .hotels
       } else {
           self.selectedContentType = .airports
       }
   }
   
   var navigationTitle: String {
       mode.title
   }
   
   var searchPlaceholder: String {
       mode.searchPlaceholder
   }
   
   var primaryActionTitle: String {
       switch selectedContentType {
       case .hotels:
           return "Show Hotels"
       case .airports:
           return "Show Airports"
       }
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
       
       let fallbackCoordinate = CLLocationCoordinate2D(
           latitude: 45.5017,
           longitude: -73.5673
       )
       
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
   
   func coordinate(
       for destination: Destination,
       hotels: [Hotel],
       airports: [Airport]
   ) -> CLLocationCoordinate2D? {
       switch selectedContentType {
       case .hotels:
           if let hotel = getHotels(for: destination, from: hotels).first {
               return CLLocationCoordinate2D(
                   latitude: hotel.latitude,
                   longitude: hotel.longitude
               )
           }
       case .airports:
           if let airport = getAirports(for: destination, from: airports).first {
               return CLLocationCoordinate2D(
                   latitude: airport.latitude,
                   longitude: airport.longitude
               )
           }
       }
       
       if let hotel = getHotels(for: destination, from: hotels).first {
           return CLLocationCoordinate2D(
               latitude: hotel.latitude,
               longitude: hotel.longitude
           )
       }
       
       if let airport = getAirports(for: destination, from: airports).first {
           return CLLocationCoordinate2D(
               latitude: airport.latitude,
               longitude: airport.longitude
           )
       }
       
       return nil
   }
    
    /*
    func destinationCoordinate(for destination: Destination) -> CLLocationCoordinate2D? {
        guard let latitude = destination.latitude,
              let longitude = destination.longitude else {
            return nil
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
     */
    
   private func updateCamera(center: CLLocationCoordinate2D, distance: Double) {
       camera = .camera(
           MapCamera(
               centerCoordinate: center,
               distance: distance
           )
       )
   }
}
