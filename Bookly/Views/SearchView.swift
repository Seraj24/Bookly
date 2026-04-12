//
//  SearchView.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var vm = SearchViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                headerSection
                
                HStack(spacing: 16) {
                    Button {
                        vm.openHotelSearch()
                    } label: {
                        searchCategoryCard(
                            title: "Hotels",
                            subtitle: "Find stays, rooms, and destination deals.",
                            icon: "bed.double.fill"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        vm.openFlightSearch()
                    } label: {
                        searchCategoryCard(
                            title: "Flights",
                            subtitle: "Compare routes, dates, and flight options.",
                            icon: "airplane"
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                Button {
                    vm.openMapSearch()
                } label: {
                    searchCategoryCard(
                        title: "Use a Map",
                        subtitle: "Browse destinations, hotels, and airports on a map.",
                        icon: "map"
                    )
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
        .background(Color("BackgroundColor"))
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $vm.route) { route in
            switch route {
            case .hotelSearch:
                HotelSearchView { request in
                    vm.showHotelResults(request: request)
                }
                
            case .flightSearch:
                FlightSearchView { request in
                    vm.showFlightResults(request: request)
                }
                
            case .mapSearch:
                DestinationMapBrowseView(
                    preselectedDestination: nil,
                    onShowHotels: { destination, checkInDate, checkOutDate in
                        vm.showHotelsFromMap(
                            destination: destination,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate
                        )
                    },
                    onShowFlights: { departureAirport, arrivalAirport in
                        vm.showFlightsFromMap(
                            departureAirport: departureAirport,
                            arrivalAirport: arrivalAirport
                        )
                    },
                    onHotelPicked: { hotel, checkInDate, checkOutDate in
                        vm.showHotelDetails(
                            hotel,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate
                        )
                    }
                )
                
            case .hotelResults(let request):
                HotelsResultsView(request: request)
                
            case .flightResults(let request):
                FlightsResultsView(request: request)
                
            case .hotelDetails(let hotel, let request):
                HotelDetailsView(
                    hotel: hotel,
                    request: request
                )
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Search")
                .font(.system(size: 30, weight: .bold))
            
            Text("Choose what you want to search for.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func searchCategoryCard(title: String, subtitle: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color("PrimaryColor"))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("PrimaryColor"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
        .background(Color("CardColor").opacity(0.96))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }
}
