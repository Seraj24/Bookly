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

    var titleText: String {
        "\(request.fromCity) → \(request.toCity)"
    }

    var subtitleText: String {
        "\(flights.count) flight\(flights.count == 1 ? "" : "s") found"
    }

    init(request: FlightSearchRequest) {
        self.request = request
        loadFlights()
    }

    func loadFlights() {
        isLoading = true

        let formattedDate = request.departureDate.formatted(date: .abbreviated, time: .omitted)

        flights = [
            Flight(
                airline: "Air Canada",
                fromCity: request.fromCity,
                toCity: request.toCity,
                departureTime: "08:30",
                arrivalTime: "11:45",
                date: formattedDate,
                duration: "3h 15m",
                price: 420,
                cabin: "Economy",
                stopsText: "Non-stop"
            ),
            Flight(
                airline: "Porter",
                fromCity: request.fromCity,
                toCity: request.toCity,
                departureTime: "10:10",
                arrivalTime: "14:00",
                date: formattedDate,
                duration: "3h 50m",
                price: 365,
                cabin: "Economy",
                stopsText: "1 stop"
            ),
            Flight(
                airline: "WestJet",
                fromCity: request.fromCity,
                toCity: request.toCity,
                departureTime: "18:20",
                arrivalTime: "21:35",
                date: formattedDate,
                duration: "3h 15m",
                price: 510,
                cabin: "Premium Economy",
                stopsText: "Non-stop"
            )
        ]

        isLoading = false
    }
}
