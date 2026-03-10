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

// Since I haven't implemented the map yet, this view acts as the home view for this iteration
struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    
    @State var showDatePicker: Bool = false
    @State var showHotelDatePicker: Bool = false
    
    @State private var showPassengersSheet = false
    @State private var showHotelGuestsSheet = false
    
    @FocusState private var focusedField: ActiveField?
    
    @State private var pickingField: PickingField = .departure
    private enum PickingField { case departure, `return` }
    
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
                    searchCardHotels
                } else {
                    searchCardFlights
                }
                
                featuredSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color("BackgroundColor"))
        .navigationDestination(item: $vm.route) { route in
            switch route {
            case .hotels(let destination):
                HotelsResultsView(destination: destination)
            case .flights(let request):
                FlightsResultsView(request: request)
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
            
            Text("Search deals on hotels, flights, and more")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func dismissSuggestions() {
        focusedField = nil
    }
    
    private var searchCardHotels: some View {
        VStack(spacing: 12) {
            
            SearchSuggestionField(
                placeholder: "Where to?",
                icon: "mappin.and.ellipse",
                text: $vm.destination,
                field: .hotelDestination,
                focusedField: $focusedField,
                suggestions: vm.destinationSuggestions,
                rowIcon: "mappin"
            ) { city in
                vm.destination = city
                dismissSuggestions()
            }
            
            Divider()
            
            HStack {
                Label("Dates", systemImage: "calendar")
                    .foregroundStyle(.secondary)
                Spacer()
                
                Text(vm.date.formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.blue)
                    .onTapGesture { showHotelDatePicker = true }
            }
            
            Divider()
            
            Button {
                showHotelGuestsSheet = true
            } label: {
                HStack {
                    Label("Guests", systemImage: "person.2")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(vm.hotelGuests)")
                        .foregroundStyle(Color("PrimaryColor"))
                }
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showHotelGuestsSheet) {
                CountSelector(
                    title: "Guests",
                    count: $vm.hotelGuests
                )
                .presentationDetents([.medium])
            }
            
            Button {
                vm.searchTapped()
            } label: {
                Text("Search")
                    .frame(maxWidth: .infinity)
            }
            .fontWeight(.semibold)
            .buttonStyle(.borderedProminent)
            .tint(Color("PrimaryColor"))
            .padding(.top, 4)
            .disabled(!vm.canSearchHotels)
            .opacity(vm.canSearchHotels ? 1 : 0.6)
        }
        .padding()
        .background(Color("CardColor").opacity(0.96))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
        .sheet(isPresented: $showHotelDatePicker) {
            VStack(spacing: 16) {
                DatePicker(
                    "Select date",
                    selection: $vm.date,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Button("Done") { showHotelDatePicker = false }
                    .buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium])
        }
    }
    
    private var searchCardFlights: some View {
        VStack(spacing: 12) {

            Picker("Trip type", selection: $vm.tripType) {
                Text("One-way").tag(TripType.oneWay)
                Text("Round trip").tag(TripType.roundTrip)
            }
            .pickerStyle(.segmented)
            .onChange(of: vm.tripType) { _, newValue in
                if newValue == .oneWay {
                    vm.returnDate = nil
                } else {
                    if vm.returnDate == nil, let d = vm.departureDate { vm.returnDate = d }
                }
            }

            
            Divider()

            VStack(spacing: 10) {
                
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
                    dismissSuggestions()
                }
                
                Divider()

                // TO
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
                    dismissSuggestions()
                }
                
                Divider()
                
                HStack {
                    Label("Departure", systemImage: "calendar")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(vm.departureDateText)
                        .foregroundStyle(Color("PrimaryColor"))
                        .onTapGesture {
                            pickingField = .departure
                            showDatePicker = true
                        }
                }
                

                if vm.tripType == .roundTrip {
                    
                    Divider()
                    
                    HStack {
                        Label("Return", systemImage: "calendar")
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(vm.returnDateText)
                            .foregroundStyle(Color("PrimaryColor"))
                            .onTapGesture {
                                pickingField = .return
                                showDatePicker = true
                            }
                    }
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
                .sheet(isPresented: $showPassengersSheet) {
                    CountSelector(
                        title: "Passengers",
                        count: $vm.flightPassengers
                    )
                    .presentationDetents([.medium])
                }

                Button {
                    vm.searchTapped()
                } label: {
                    Text("Search Flights")
                        .frame(maxWidth: .infinity)
                }
                .fontWeight(.semibold)
                .buttonStyle(.borderedProminent)
                .tint(Color("PrimaryColor"))
                .padding(.top, 4)
                .disabled(!vm.canSearchFlights)
                .opacity(vm.canSearchFlights ? 1 : 0.6)
            }
            .padding()
            .background(Color("CardColor").opacity(0.96))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
            .sheet(isPresented: $showDatePicker) {
                VStack(spacing: 16) {
                    DatePicker(
                        pickingField == .departure ? "Select departure" : "Select return",
                        selection: bindingForPicker(pickingField),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()

                    Button("Done") {
                        vm.normalizeFlightDatesIfNeeded()
                        showDatePicker = false
                    }
                    .buttonStyle(.borderedProminent)

                }
                .presentationDetents([.medium])
            }
        }
    }
    
    private func bindingForPicker(_ field: PickingField) -> Binding<Date> {
        Binding(
            get: {
                switch field {
                case .departure:
                    return vm.departureDate ?? .now
                case .return:
                    return vm.returnDate ?? vm.departureDate ?? .now
                }
            },
            set: { newValue in
                switch field {
                case .departure:
                    vm.departureDate = newValue
                    
                    if vm.tripType == .roundTrip {
                        if let r = vm.returnDate, r < newValue {
                            vm.returnDate = newValue
                        } else if vm.returnDate == nil {
                            vm.returnDate = newValue
                        }
                    }
                    
                case .return:
                    vm.returnDate = newValue
                }
            }
        )
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
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured Deals")
                    .font(.headline)
                Spacer()
                Button("See all") { }
                    .font(.subheadline)
                    .foregroundStyle(Color("PrimaryColor"))
            }
            
            VStack(spacing: 12) {
                ForEach(vm.deals) { deal in
                    DealCard(deal: deal)
                }
            }
        }
    }
}

enum HomeRoute: Hashable, Identifiable {
    case hotels(destination: String)
    case flights(request: FlightSearchRequest)
    case account
    
    var id: Self { self }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
