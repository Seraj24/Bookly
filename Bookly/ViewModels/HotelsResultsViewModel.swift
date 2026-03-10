//
//  HotelsViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine

final class HotelsResultsViewModel: ObservableObject {
    
    @Published private(set) var hotels: [Hotel] = []
    
    private var allHotels: [Hotel] = []
    
    init(destination: String, allHotels: [Hotel] = []) {
        self.allHotels = allHotels
        applyFilter(destination: destination)
    }
    
    func setHotels(_ hotels: [Hotel], destination: String) {
        self.allHotels = hotels
        applyFilter(destination: destination)
    }

    func applyFilter(destination: String) {
        
        let loweredDestination = destination
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        guard !loweredDestination.isEmpty else {
            hotels = allHotels
            return
        }

        hotels = allHotels.filter {
            ($0.destination?.city ?? "")
                .lowercased()
                .contains(loweredDestination)
        }
    }
}
