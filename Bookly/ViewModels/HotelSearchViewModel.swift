//
//  HotelSearchViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import Foundation
import Combine

final class HotelSearchViewModel: ObservableObject {
    @Published var destination: String = ""
    @Published var date: Date = .now
    @Published var hotelGuests: Int = 1
    
    private var holder: BooklyHolder?
    
    func configure(holder: BooklyHolder) {
        self.holder = holder
    }
    
    var locations: [String] {
        guard let holder else { return [] }
        
        return holder.destinations
            .map { $0.city ?? "" }
            .filter { !$0.isEmpty }
            .sorted()
    }
    
    var destinationSuggestions: [String] {
        let trimmed = destination.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return Array(locations.prefix(6)) }
        return locations.filter { $0.lowercased().hasPrefix(trimmed) }
    }
    
    var canSearchHotels: Bool {
        !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func makeDestination() -> String? {
        let trimmed = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
    
    func clear() {
        destination = ""
        date = .now
        hotelGuests = 1
    }
}
