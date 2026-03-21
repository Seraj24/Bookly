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
    case hotelResults(request: HotelSearchRequest)
    case flightResults(request: FlightSearchRequest)
    
    var id: Self { self }
}

final class SearchViewModel: ObservableObject {
    @Published var route: SearchRoute?
    
    func openHotelSearch() {
        route = .hotelSearch
    }
    
    func openFlightSearch() {
        route = .flightSearch
    }
    
    func showHotelResults(request: HotelSearchRequest) {
        route = .hotelResults(request: request)
    }
    
    func showFlightResults(request: FlightSearchRequest) {
        route = .flightResults(request: request)
    }
}
