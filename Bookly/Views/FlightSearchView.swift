//
//  FlightSearchCard.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import SwiftUI

struct FlightSearchView: View {
    @EnvironmentObject private var holder: BooklyHolder
    @StateObject private var vm = FlightSearchViewModel()

    let onSearch: (FlightSearchRequest) -> Void
    let showHeader: Bool

    @State private var showDatePicker = false
    @State private var showPassengersSheet = false
    @FocusState private var focusedField: ActiveField?
    
    init(
        showHeader: Bool = true,
        onSearch: @escaping (FlightSearchRequest) -> Void
    ) {
        self.showHeader = showHeader
        self.onSearch = onSearch
        
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                if (showHeader) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Search Flights")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Compare routes and plan your trip")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                

                VStack(spacing: 12) {
                    Picker("Trip type", selection: $vm.tripType) {
                        Text("One-way").tag(TripType.oneWay)
                        Text("Round trip").tag(TripType.roundTrip)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: vm.tripType) { _, newValue in
                        if newValue == .oneWay {
                            vm.returnDate = nil
                        } else if vm.returnDate == nil {
                            vm.returnDate = vm.departureDate
                        }
                    }

                    Divider()

                    SearchSuggestionField(
                        placeholder: "From",
                        icon: "airplane.departure",
                        text: $vm.fromCity,
                        field: .from,
                        focusedField: $focusedField,
                        suggestions: vm.airportsSuggestionsFrom,
                        rowIcon: "airplane.departure"
                    ) { city in
                        vm.fromCity = city
                        focusedField = nil
                    }

                    Divider()

                    SearchSuggestionField(
                        placeholder: "To",
                        icon: "airplane.arrival",
                        text: $vm.toCity,
                        field: .to,
                        focusedField: $focusedField,
                        suggestions: vm.airportsSuggestionsTo,
                        rowIcon: "airplane.arrival"
                    ) { city in
                        vm.toCity = city
                        focusedField = nil
                    }

                    Divider()

                    HStack {
                        let dateText = vm.tripType == .oneWay ? "Departure Date" : "Dates"
                        
                        Label(dateText, systemImage: "calendar")
                            .foregroundStyle(.secondary)

                        Spacer()
                        
                        let returnDate = vm.tripType == .oneWay ? "" : " - \(vm.returnDateText)"
                        
                        Text("\(vm.departureDateText)\(returnDate)")
                            .lineLimit(1)
                    }
                    .onTapGesture {
                        showDatePicker = true
                    }
                    
                    Divider()

                    Button {
                        showPassengersSheet = true
                    } label: {
                        HStack {
                            Label("Passengers", systemImage: "person.2")
                                .foregroundStyle(.secondary)

                            Spacer()

                            Text("\(vm.flightPassengers)")
                                .foregroundStyle(Color("PrimaryColor"))
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        guard let request = vm.makeRequest() else { return }
                        onSearch(request)
                    } label: {
                        Text("Search Flights")
                            .frame(maxWidth: .infinity)
                    }
                    .fontWeight(.semibold)
                    .buttonStyle(.borderedProminent)
                    .tint(Color("PrimaryColor"))
                    .padding(.top, 6)
                    .disabled(!vm.canSearchFlights)
                    .opacity(vm.canSearchFlights ? 1 : 0.6)
                }
                .padding(18)
                .background(Color("CardColor").opacity(0.96))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("BackgroundColor").ignoresSafeArea())
        .onAppear {
            vm.configure(holder: holder)
        }
        .onDisappear {
            focusedField = nil
        }
        .sheet(isPresented: $showPassengersSheet) {
            CountSelector(
                title: "Passengers",
                count: $vm.flightPassengers
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Departure")
                        .font(.headline)

                    DatePicker(
                        "Departure",
                        selection: Binding(
                            get: { vm.departureDate},
                            set: { newValue in
                                vm.departureDate = newValue

                                if vm.tripType == .roundTrip {
                                    if let returnDate = vm.returnDate, returnDate < newValue {
                                        vm.returnDate = newValue
                                    } else if vm.returnDate == nil {
                                        vm.returnDate = newValue
                                    }
                                }
                            }
                        ),
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                }

                if vm.tripType == .roundTrip {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Return")
                            .font(.headline)

                        DatePicker(
                            "Return",
                            selection: Binding(
                                get: { vm.returnDate ?? vm.departureDate ?? .now },
                                set: { newValue in
                                    vm.returnDate = newValue
                                }
                            ),
                            in: (vm.departureDate ?? Date())...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                    }
                }

                Button("Done") {
                    vm.normalizeFlightDatesIfNeeded()
                    showDatePicker = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .presentationDetents([.large])
        }
    }
}
