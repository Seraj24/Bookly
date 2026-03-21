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
    @Published var checkInDate: Date = .now
    @Published var checkOutDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
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
    
    var checkInDateText: String {
        checkInDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var checkOutDateText: String {
        checkOutDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var destinationSuggestions: [String] {
        let trimmed = destination.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return Array(locations.prefix(6)) }
        return locations.filter { $0.lowercased().hasPrefix(trimmed) }
    }
    
    var canSearchHotels: Bool {
        !destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func makeRequest() -> HotelSearchRequest? {
        guard canSearchHotels else { return nil }
        
        let destination = self.destination.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return HotelSearchRequest(
            destination: destination,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
        )
    }
    
    func clear() {
        destination = ""
        checkInDate = .now
        checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        hotelGuests = 1
    }
}
