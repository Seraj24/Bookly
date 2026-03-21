//
//  HomeViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine
import CoreData

enum TripType: String, CaseIterable {
    case oneWay = "One-way"
    case roundTrip = "Round trip"
}

final class HomeViewModel: ObservableObject {
    @Published var selectedCategory: Category = .hotels
    @Published var route: HomeRoute? = nil
    @Published private(set) var deals: [Deal] = ExampleDeals.sample
    
    private var holder: BooklyHolder?
    private var context: NSManagedObjectContext?
    
    func configure(holder: BooklyHolder, context: NSManagedObjectContext) {
        self.holder = holder
        self.context = context
    }
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func showHotels(request: HotelSearchRequest) {
        route = .hotels(request: request)
    }
    
    func showFlights(request: FlightSearchRequest) {
        route = .flights(request: request)
    }
}
    
