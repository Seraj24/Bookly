//
//  FlightsResultsView.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct FlightsResultsView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    
    @StateObject private var vm: FlightsResultsViewModel

    init(request: FlightSearchRequest) {
        _vm = StateObject(wrappedValue: FlightsResultsViewModel(request: request))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                
                if vm.isLoading {
                    ProgressView("Loading flights...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                    
                } else if vm.flights.isEmpty {
                    ContentUnavailableView(
                        "No flights found",
                        systemImage: "airplane",
                        description: Text("Try different cities or dates.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                    
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.flights) { flight in
                            NavigationLink {
                                FlightDetailsView(flight: flight)
                            } label: {
                                FlightRow(flight: flight)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Flights")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.setFlights(holder.flights)
            print("TOTAL HOLDER FLIGHTS:", holder.flights.count)
            for flight in holder.flights {
                print(
                    "FLIGHT:",
                    flight.flightNumber ?? "nil",
                    flight.departureAirport?.code ?? "nil",
                    "->",
                    flight.arrivalAirport?.code ?? "nil"
                )
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(vm.titleText)
                .font(.title3)
                .fontWeight(.bold)

            Text(vm.subtitleText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    //FlightsResultsView()
}
