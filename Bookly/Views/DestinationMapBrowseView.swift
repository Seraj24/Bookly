//
//  DestinationMapBrowseView.swift
//  Bookly
//
//  Created by user938962 on 3/24/26.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreData

struct DestinationMapBrowseView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = DestinationMapBrowseViewModel()
    
    let onShowHotels: (Destination, Date, Date) -> Void
    let onShowFlights: (Airport, Airport) -> Void
    let onHotelPicked: (Hotel, Date, Date) -> Void
    
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
        
        return previewCoordinate(for: selectedDestination)
    }
    
    var body: some View {
        ZStack {
            mapSection
            
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
                    .buttonStyle(.plain)
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
                        .buttonStyle(.plain)
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
                        .buttonStyle(.plain)
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
    
    private var mapSection: some View {
        Map(position: $vm.camera) {
            
            if let userLocation = locationManager.userLocation {
                Marker("You", coordinate: userLocation)
                    .tint(.blue)
            }
            
            ForEach(filteredDestinations, id: \.objectID) { destination in
                if let coordinate = previewCoordinate(for: destination) {
                    Marker(
                        "\(destination.city ?? ""), \(destination.country ?? "")",
                        coordinate: coordinate
                    )
                    .tint(.red)
                }
            }
            
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
                            onHotelPicked(hotel, vm.checkInDate, vm.checkOutDate)
                        } label: {
                            Image(systemName: "bed.double.fill")
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.green)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
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
                            vm.selectAirport(airport)
                        } label: {
                            Image(systemName: "airplane")
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(airportSelectionColor(for: airport))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .mapStyle(.standard)
    }
    
    private var bottomPanel: some View {
        VStack(spacing: 12) {
            searchSection
            contentPickerSection
            
            if vm.selectedContentType == .hotels {
                hotelDatesSection
            } else {
                airportStepSection
            }
            
            destinationSelectionSection
            
            if let selectedDestination = vm.selectedDestination {
                selectedDestinationCard(for: selectedDestination)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    private var searchSection: some View {
        HStack(spacing: 10) {
            TextField(vm.searchPlaceholder, text: $vm.searchText)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
            
            Button {
                guard let first = filteredDestinations.first else { return }
                
                vm.selectDestination(first)
                
                if let coordinate = previewCoordinate(for: first) {
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
            .buttonStyle(.plain)
            .disabled(vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
    
    private var contentPickerSection: some View {
        Picker("Content Type", selection: $vm.selectedContentType) {
            Text("Hotels").tag(DestinationBrowseContentType.hotels)
            Text("Airports").tag(DestinationBrowseContentType.airports)
        }
        .pickerStyle(.segmented)
    }
    
    private var hotelDatesSection: some View {
        VStack(spacing: 10) {
            DatePicker(
                "Check-in",
                selection: $vm.checkInDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            
            DatePicker(
                "Check-out",
                selection: $vm.checkOutDate,
                in: vm.checkInDate...,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
        }
        .onChange(of: vm.checkInDate) { _, _ in
            vm.normalizeDatesIfNeeded()
        }
    }
    
    private var airportStepSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Button {
                    vm.chooseDepartureStep()
                } label: {
                    Text("Departure")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            vm.flightSelectionStep == .departure
                            ? Color.blue
                            : Color(.systemGray5)
                        )
                        .foregroundStyle(
                            vm.flightSelectionStep == .departure
                            ? Color.white
                            : Color.primary
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                
                Button {
                    vm.chooseArrivalStep()
                } label: {
                    Text("Arrival")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            vm.flightSelectionStep == .arrival
                            ? Color.blue
                            : Color(.systemGray5)
                        )
                        .foregroundStyle(
                            vm.flightSelectionStep == .arrival
                            ? Color.white
                            : Color.primary
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            
            Text(vm.flightSelectionPrompt)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let departure = vm.selectedDepartureAirport {
                Text("Departure: \(vm.airportDisplayText(departure))")
                    .font(.subheadline)
            }
            
            if let arrival = vm.selectedArrivalAirport {
                Text("Arrival: \(vm.airportDisplayText(arrival))")
                    .font(.subheadline)
            }
        }
    }
    
    private var destinationSelectionSection: some View {
        Group {
            if !filteredDestinations.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(filteredDestinations, id: \.objectID) { destination in
                            Button {
                                vm.selectDestination(destination)
                                
                                if let coordinate = previewCoordinate(for: destination) {
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
        }
    }
    
    private func selectedDestinationCard(for destination: Destination) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(destination.city ?? "Unknown City")
                        .font(.headline)
                    
                    Text(destination.country ?? "Unknown Country")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if vm.selectedContentType == .hotels {
                    Button("Show Hotels") {
                        onShowHotels(destination, vm.checkInDate, vm.checkOutDate)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Show Flights") {
                        guard let departure = vm.selectedDepartureAirport,
                              let arrival = vm.selectedArrivalAirport else {
                            return
                        }
                        
                        onShowFlights(departure, arrival)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!vm.canShowFlights)
                }
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
                        onHotelPicked(hotel, vm.checkInDate, vm.checkOutDate)
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
                        vm.selectAirport(airport)
                    } label: {
                        HStack {
                            Text(vm.airportDisplayText(airport))
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            airportSelectionLabel(for: airport)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func previewCoordinate(for destination: Destination) -> CLLocationCoordinate2D? {
        if let hotel = vm.getHotels(for: destination, from: holder.hotels).first {
            return CLLocationCoordinate2D(
                latitude: hotel.latitude,
                longitude: hotel.longitude
            )
        }
        
        if let airport = vm.getAirports(for: destination, from: holder.airports).first {
            return CLLocationCoordinate2D(
                latitude: airport.latitude,
                longitude: airport.longitude
            )
        }
        
        return nil
    }
    
    private func airportSelectionColor(for airport: Airport) -> Color {
        if vm.selectedDepartureAirport?.objectID == airport.objectID {
            return .blue
        }
        
        if vm.selectedArrivalAirport?.objectID == airport.objectID {
            return .purple
        }
        
        return .orange
    }
    
    @ViewBuilder
    private func airportSelectionLabel(for airport: Airport) -> some View {
        if vm.selectedDepartureAirport?.objectID == airport.objectID {
            Text("Departure")
                .font(.caption)
                .foregroundStyle(.blue)
        } else if vm.selectedArrivalAirport?.objectID == airport.objectID {
            Text("Arrival")
                .font(.caption)
                .foregroundStyle(.purple)
        } else {
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
    }
}


