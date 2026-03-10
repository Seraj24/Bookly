//
//  FlightsResultsViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import Foundation
import Combine

final class FlightsResultsViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var isLoading = false

    let request: FlightSearchRequest
    private var allFlights: [Flight] = []

    var titleText: String {
        "\(request.fromCity) → \(request.toCity)"
    }

    var subtitleText: String {
        "\(flights.count) flight\(flights.count == 1 ? "" : "s") found"
    }

    init(request: FlightSearchRequest, allFlights: [Flight] = []) {
        self.request = request
        self.allFlights = allFlights
        loadFlights()
    }
    
    func setFlights(_ flights: [Flight]) {
        self.allFlights = flights
        loadFlights()
    }

    func loadFlights() {
        isLoading = true

        let fromCode = airportCode(from: request.fromCity)
        let toCode = airportCode(from: request.toCity)

        flights = allFlights.filter { flight in
            let departureCode = (flight.departureAirport?.code ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            
            let arrivalCode = (flight.arrivalAirport?.code ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            return departureCode == fromCode && arrivalCode == toCode
        }

        isLoading = false
    }

    private func airportCode(from text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let open = trimmed.lastIndex(of: "("),
              let close = trimmed.lastIndex(of: ")"),
              open < close else {
            return trimmed.lowercased()
        }
        
        let code = trimmed[trimmed.index(after: open)..<close]
        return code.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    private func formattedAirportText(for airport: Airport?) -> String {
        let name = airport?.name ?? ""
        let code = airport?.code ?? ""
        
        if !name.isEmpty && !code.isEmpty {
            return "\(name) (\(code))"
        }
        
        return name
    }
}
