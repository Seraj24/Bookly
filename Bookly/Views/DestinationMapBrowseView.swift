//
//  DestinationMapBrowseView.swift
//  Bookly
//
//  Created by user938962 on 3/24/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct DestinationMapBrowseView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm: DestinationMapBrowseViewModel
    
    let onPrimaryAction: (Destination, DestinationBrowseContentType, DestinationBrowseMode) -> Void
    let onHotelPicked: (Hotel) -> Void
    let onAirportPicked: (Airport, DestinationBrowseMode) -> Void
    
    init(
        mode: DestinationBrowseMode,
        onPrimaryAction: @escaping (Destination, DestinationBrowseContentType, DestinationBrowseMode) -> Void,
        onHotelPicked: @escaping (Hotel) -> Void,
        onAirportPicked: @escaping (Airport, DestinationBrowseMode) -> Void
    ) {
        _vm = StateObject(wrappedValue: DestinationMapBrowseViewModel(mode: mode))
        self.onPrimaryAction = onPrimaryAction
        self.onHotelPicked = onHotelPicked
        self.onAirportPicked = onAirportPicked
    }
    
    private var filteredDestinations: [Destination] {
        vm.filteredDestinations(from: holder.destinations)
    }
    
    private var visibleHotels: [Hotel] {
        vm.visibleHotels(from: holder.hotels)
    }
    
    private var visibleAirports: [Airport] {
        vm.visibleAirports(from: holder.airports)
    }
    
    private var selectedCoordinate: CLLocationCoordinate2D? {
        guard let selectedDestination = vm.selectedDestination else {
            return nil
        }
        
        return vm.coordinate(
            for: selectedDestination,
            hotels: holder.hotels,
            airports: holder.airports
        )
    }
    
    var body: some View {
        ZStack {
            mapView
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            vm.goToUserLocation(locationManager.userLocation)
                        }
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .shadow(radius: 4)
                    .padding()
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Button {
                            withAnimation {
                                vm.zoomIn(center: selectedCoordinate ?? locationManager.userLocation)
                            }
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .shadow(radius: 4)
                        
                        Button {
                            withAnimation {
                                vm.zoomOut(center: selectedCoordinate ?? locationManager.userLocation)
                            }
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(vm.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            bottomPanel
        }
        .onAppear {
            vm.setupInitialCamera(userLocation: locationManager.userLocation)
        }
        .onReceive(locationManager.$userLocation) { newValue in
            vm.setupInitialCamera(userLocation: newValue)
        }
    }
    
    private var mapView: some View {
        Map(position: $vm.camera) {
            
            if let userLocation = locationManager.userLocation {
                Marker("You", coordinate: userLocation)
                    .tint(.blue)
            }
            
            /* To show a red marker on a city/destination but the current database and CoreData model does not support cooridinations on the model Destination
             
             ForEach(filteredDestinations, id: \.objectID) { destination in
                 if let coordinate = vm.destinationCoordinate(for: destination) {
                     Marker(
                         destination.city ?? "Destination",
                         coordinate: coordinate
                     )
                     .tint(.red)
                 }
             }
             */
            
            
            if vm.selectedContentType == .hotels {
                ForEach(visibleHotels, id: \.objectID) { hotel in
                    Annotation(
                        hotel.name ?? "Hotel",
                        coordinate: CLLocationCoordinate2D(
                            latitude: hotel.latitude,
                            longitude: hotel.longitude
                        )
                    ) {
                        Button {
                            onHotelPicked(hotel)
                        } label: {
                            Image(systemName: "bed.double.fill")
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.green)
                                .clipShape(Circle())
                        }
                    }
                }
            } else {
                ForEach(visibleAirports, id: \.objectID) { airport in
                    Annotation(
                        airport.name ?? "Airport",
                        coordinate: CLLocationCoordinate2D(
                            latitude: airport.latitude,
                            longitude: airport.longitude
                        )
                    ) {
                        Button {
                            onAirportPicked(airport, vm.mode)
                        } label: {
                            Image(systemName: "airplane")
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.orange)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .mapStyle(.standard)
    }
    
    private var bottomPanel: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                TextField(vm.searchPlaceholder, text: $vm.searchText)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                
                Button {
                    guard let first = filteredDestinations.first else { return }
                    
                    vm.selectDestination(first)
                    
                    if let coordinate = vm.coordinate(
                        for: first,
                        hotels: holder.hotels,
                        airports: holder.airports
                    ) {
                        withAnimation {
                            vm.focusOnCoordinate(coordinate)
                        }
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .tint(.white)
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            Picker("Content Type", selection: $vm.selectedContentType) {
                Text("Hotels").tag(DestinationBrowseContentType.hotels)
                Text("Airports").tag(DestinationBrowseContentType.airports)
            }
            .pickerStyle(.segmented)
            
            if !filteredDestinations.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(filteredDestinations, id: \.objectID) { destination in
                            Button {
                                vm.selectDestination(destination)
                                
                                if let coordinate = vm.coordinate(
                                    for: destination,
                                    hotels: holder.hotels,
                                    airports: holder.airports
                                ) {
                                    withAnimation {
                                        vm.focusOnCoordinate(coordinate)
                                    }
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(destination.city ?? "Unknown City")
                                        .font(.headline)
                                    
                                    Text(destination.country ?? "Unknown Country")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .background(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            
            if let selectedDestination = vm.selectedDestination {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedDestination.city ?? "Unknown City")
                                .font(.headline)
                            
                            Text(selectedDestination.country ?? "Unknown Country")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(vm.primaryActionTitle) {
                            onPrimaryAction(selectedDestination, vm.selectedContentType, vm.mode)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    if vm.selectedContentType == .hotels {
                        hotelsPreviewSection
                    } else {
                        airportsPreviewSection
                    }
                }
                .padding()
                .background(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    private var hotelsPreviewSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Hotels")
                .font(.subheadline.weight(.semibold))
            
            if visibleHotels.isEmpty {
                Text("No hotels found for this destination.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(visibleHotels.prefix(3), id: \.objectID) { hotel in
                    Button {
                        onHotelPicked(hotel)
                    } label: {
                        HStack {
                            Text(hotel.name ?? "Unnamed Hotel")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var airportsPreviewSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Airports")
                .font(.subheadline.weight(.semibold))
            
            if visibleAirports.isEmpty {
                Text("No airports found for this destination.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(visibleAirports.prefix(3), id: \.objectID) { airport in
                    Button {
                        onAirportPicked(airport, vm.mode)
                    } label: {
                        HStack {
                            Text("\(airport.name ?? "Unnamed Airport") (\(airport.code ?? ""))")
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
