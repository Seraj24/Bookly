//
//  HotelsViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine

final class HotelsViewModel: ObservableObject {
    @Published private(set) var hotels: [Hotel] = []

    private let allHotels: [Hotel]

    init(destination: String, allHotels: [Hotel] = ExampleHotels.all) {
        self.allHotels = allHotels
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
            $0.city.lowercased().contains(loweredDestination)
        }
    }
}
