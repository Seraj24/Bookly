//
//  FlightDetailsView.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct FlightDetailsView: View {
    
    @EnvironmentObject private var holder: BooklyHolder
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var vm: FlightDetailsViewModel
    
    init(flight: Flight) {
        _vm = StateObject(wrappedValue: FlightDetailsViewModel(flight: flight))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                routeCard
                detailsCard
                cabinSection
                bookingCard
            }
            .padding()
        }
        .navigationTitle("Flight Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            vm.configure(holder: holder, context: context)
        }
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "airplane")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.airlineText)
                        .font(.headline)
                    
                    Text(vm.cabinText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(vm.priceText)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Divider()
            
            Text(vm.descriptionText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var routeCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.departureTimeText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(vm.fromCityText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    Text(vm.durationText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .frame(width: 8, height: 8)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: "airplane")
                            .foregroundStyle(.blue)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.secondary)
                        
                        Circle()
                            .frame(width: 8, height: 8)
                    }
                    .foregroundStyle(.secondary)
                    
                    Text(vm.stopsText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: 120)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(vm.arrivalTimeText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(vm.toCityText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                Label("Date", systemImage: "calendar")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(vm.dateText)
                    .foregroundStyle(.primary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var detailsCard: some View {
        VStack(spacing: 14) {
            detailsRow(title: "Airline", value: vm.airlineText, systemImage: "building.2")
            Divider()
            detailsRow(title: "Cabin", value: vm.cabinText, systemImage: "seat.side.right")
            Divider()
            detailsRow(title: "Duration", value: vm.durationText, systemImage: "clock")
            Divider()
            detailsRow(title: "Stops", value: vm.stopsText, systemImage: "point.topleft.down.curvedto.point.bottomright.up")
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var cabinSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Cabin")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ForEach(vm.cabins, id: \.objectID) { cabin in
                cabinCard(cabin)
            }
            
            if let selectedCabin = vm.selectedCabin {
                quantityCard(for: selectedCabin)
            }
        }
    }
    
    private func cabinCard(_ cabin: Cabin) -> some View {
        
        SelectionOptionCard(
            title: cabin.cabinClass ?? "Unknown Cabin",
            subtitle: "Available seats: \(cabin.remainingSeats)",
            priceText: String(format: "$%.0f", cabin.price),
            priceCaption: "per seat",
            benefits: [
                OptionBenefit(
                    text: "Carry-on included",
                    systemImage: "checkmark.circle.fill",
                    color: .green
                ),
                OptionBenefit(
                    text: "Flexible booking",
                    systemImage: "checkmark.circle.fill",
                    color: .green
                ),
                OptionBenefit(
                    text: "Comfortable seating",
                    systemImage: "seat.side.right.fill",
                    color: .secondary
                )
            ],
            isSelected: vm.isSelected(cabin),
            actionTitle: vm.isSelected(cabin) ? "Selected" : "Select",
            onSelect: {
                vm.selectCabin(cabin)
            }
        )
    }
    
    private func quantityCard(for cabin: Cabin) -> some View {
        QuantitySelectorCard(
            title: "Passenger Quantity",
            subtitle: "Selected cabin: \(cabin.cabinClass ?? "Unknown Cabin")",
            value: vm.selectedSeatCount,
            availabilityText: "Available: \(cabin.remainingSeats)",
            canDecrease: vm.selectedSeatCount > 1,
            canIncrease: vm.selectedSeatCount < vm.maxSelectableSeats,
            onDecrease: {
                vm.decreaseSeatCount()
            },
            onIncrease: {
                vm.increaseSeatCount()
            }
        )
    }
    
    private var bookingCard: some View {
        VStack(spacing: 14) {
            if let selectedCabin = vm.selectedCabin {
                HStack {
                    Text("Selected")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(selectedCabin.cabinClass ?? "Unknown Cabin") × \(vm.selectedSeatCount)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Price")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(vm.totalPriceText)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
            
            Button {
                print("Book flight tapped")
                print("Cabin: \(vm.selectedCabin?.cabinClass ?? "None")")
                print("Seats: \(vm.selectedSeatCount)")
            } label: {
                Text("Book Flight")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
            .disabled(!vm.canBook)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func detailsRow(title: String, value: String, systemImage: String) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}
