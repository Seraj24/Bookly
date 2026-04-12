//
//  HomeView.swift
//  Bookly
//
//  Created by user938962 on 2/7/26.
//

import SwiftUI

enum ActiveField {
    case none
    case from
    case to
    case hotelDestination
}

struct HomeView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var vm: HomeViewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                HStack {
                    Text("Bookly")
                        .font(.system(size: 34, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        vm.route = .account
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 37, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 48, height: 48)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
                
                topBar
                categoryChips
                
                if vm.selectedCategory == .hotels {
                    HotelSearchView(showHeader: false) { request in
                        vm.showHotels(request: request)
                    }
                } else {
                    FlightSearchView(showHeader: false) { request in
                        vm.showFlights(request: request)
                    }
                }
                
                destinationsSection
                popularHotelsSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color("BackgroundColor"))
        .onAppear {
            vm.configure(holder: holder, context: context)
        }
        .navigationDestination(item: $vm.route) { route in
            switch route {
            case .hotels(let request):
                HotelsResultsView(request: request)
            case .flights(let request):
                FlightsResultsView(request: request)
            case .hotelDetails(let hotel, let request):
                    HotelDetailsView(hotel: hotel, request: request)
            case .destinationMap(let selectedDestination):
                DestinationMapBrowseView(
                    preselectedDestination: selectedDestination,
                    onShowHotels: { destination, checkIn, checkOut in
                        vm.showHotels(
                            request: HotelSearchRequest(
                                destination: destination.city ?? "",
                                checkInDate: checkIn,
                                checkOutDate: checkOut
                            )
                        )
                    },
                    onShowFlights: { departure, arrival in
                        vm.showFlights(
                            request: FlightSearchRequest(
                                fromCity: departure.destination?.city ?? "",
                                toCity: arrival.destination?.city ?? "",
                                departureDate: Date(),
                                returnDate: nil,
                                tripType: .oneWay
                            )
                        )
                    },
                    onHotelPicked: { hotel, checkIn, checkOut in
                        vm.route = .hotelDetails(
                            hotel: hotel,
                            request: HotelSearchRequest(
                                destination: hotel.destination?.city ?? "",
                                checkInDate: checkIn,
                                checkOutDate: checkOut
                            )
                        )
                    }
                )
                
            case .account:
                AccountView()
            }
        }
    }
    
    private var topBar: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Find your next trip")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Discover destinations, hotels, flights, and more")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(Category.allCases) { cat in
                    CategoryChip(
                        category: cat,
                        isSelected: vm.selectedCategory == cat
                    ) {
                        vm.selectCategory(cat)
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
    
    private var destinationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Destinations")
                    .font(.headline)
                
                Spacer()
                
                Button("See all") {
                    vm.showDestinationMap()
                }
                .font(.subheadline)
                .foregroundStyle(Color("PrimaryColor"))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(vm.destinations) { destination in
                        Button {
                            vm.showDestinationOnMap(destination.destination)
                        } label: {
                            DestinationCard(item: destination)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private var popularHotelsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular Hotels")
                    .font(.headline)
                
                Spacer()
                
                Button("See all") {
                    vm.showDestinationMap()
                }
                .font(.subheadline)
                .foregroundStyle(Color("PrimaryColor"))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(vm.popularHotels) { hotel in
                        Button {
                            vm.showHotelDetails(hotel.hotel)
                        } label: {
                            PopularHotelCard(item: hotel)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

enum HomeRoute: Hashable, Identifiable {
    case hotels(request: HotelSearchRequest)
    case flights(request: FlightSearchRequest)
    case hotelDetails(hotel: Hotel, request: HotelSearchRequest)
    case destinationMap(selectedDestination: Destination?)
    case account
    
    var id: Self { self }
}
