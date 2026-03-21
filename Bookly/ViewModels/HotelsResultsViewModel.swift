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
    
    
    let request: HotelSearchRequest
    private var allHotels: [Hotel] = []
    
    init(request: HotelSearchRequest, allHotels: [Hotel] = []) {
        self.allHotels = allHotels
        self.request = request
        applyFilter(destination: request.destination)
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
