//
//  HomeViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var destination: String = ""
    @Published var fromCity: String = ""
    @Published var toCity: String = ""
    
    @Published var selectedCategory: Category = .hotels
    
    @Published var route: HomeRoute? = nil
    
    
    // Data (temporary)
    @Published private(set) var deals: [Deal] = ExampleDeals.sample
    
    let locations: [String] = [
            "Montreal", "Toronto", "Vancouver", "New York",
            "Miami", "Los Angeles", "Paris", "London", "Dubai"
        ]

    var destinationSuggestions: [String] {
        
        let trimmeDestination = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        let loweredDestination = trimmeDestination.lowercased()

        if loweredDestination.isEmpty {
            return Array(locations.prefix(6))
        }

        return locations.filter { $0.lowercased().contains(loweredDestination) }
    }
    
    var canSearchHotels: Bool {
        !destination.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var canSearchFlights: Bool {
        !fromCity.trimmingCharacters(in: .whitespaces).isEmpty &&
        !toCity.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func searchTapped() {
        switch selectedCategory {
            
            case .hotels:
            guard canSearchHotels else { return }
                let dest = destination.trimmingCharacters(in: .whitespacesAndNewlines)
                route = .hotels(destination: dest)
            case . flights:
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
    
    
