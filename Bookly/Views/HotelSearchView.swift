//
//  HotelSearchCard.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import SwiftUI

struct HotelSearchView: View {
    @EnvironmentObject private var holder: BooklyHolder
    @StateObject private var vm = HotelSearchViewModel()

    let onSearch: (HotelSearchRequest) -> Void
    let showHeader: Bool

    @State private var showHotelDatePicker = false
    @State private var showHotelGuestsSheet = false
    @FocusState private var focusedField: ActiveField?
    
    init(
        showHeader: Bool = true,
        onSearch: @escaping (HotelSearchRequest) -> Void
    ) {
        self.showHeader = showHeader
        self.onSearch = onSearch
        
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                if (showHeader) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Search Hotels")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Find stays and destination deals")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                

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
                        focusedField = nil
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

                    Button {
                        guard let request = vm.makeRequest() else { return }
                        onSearch(request)
                    } label: {
                        Text("Search")
                            .frame(maxWidth: .infinity)
                    }
                    .fontWeight(.semibold)
                    .buttonStyle(.borderedProminent)
                    .tint(Color("PrimaryColor"))
                    .padding(.top, 6)
                    .disabled(!vm.canSearchHotels)
                    .opacity(vm.canSearchHotels ? 1 : 0.6)
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
        .sheet(isPresented: $showHotelGuestsSheet) {
            CountSelector(
                title: "Guests",
                count: $vm.hotelGuests
            )
            .presentationDetents([.medium])
        }
    }
}
