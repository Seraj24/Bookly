//
//  FlightBookingView.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import SwiftUI

struct FlightBookingView: View {
    
    @StateObject private var vm: FlightBookingViewModel
    
    init(vm: FlightBookingViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                flightSummaryCard
                routeCard
                travelerDetailsCard
                fareSummaryCard
                confirmButton
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Booking")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var flightSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(vm.airlineText)
                .font(.title3)
                .fontWeight(.bold)
            
            HStack {
                Text("Cabin")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(vm.cabinText)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Passengers")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(vm.passengerCountText)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Date")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(vm.dateText)
                    .fontWeight(.semibold)
            }
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
                    
                    Text(vm.fromText)
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
                    
                    Text("Flight")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: 120)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(vm.arrivalTimeText)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(vm.toText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var travelerDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Traveler Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("First Name", text: $vm.firstName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Last Name", text: $vm.lastName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Email", text: $vm.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
            
            TextField("Phone Number", text: $vm.phoneNumber)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.phonePad)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var fareSummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Fare Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            summaryRow("Price per passenger", vm.pricePerPassengerText)
            summaryRow("Passengers", vm.passengerCountText)
            summaryRow("Subtotal", vm.subtotalText)
            summaryRow("Taxes & fees", vm.taxesAndFeesText)
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(vm.totalText)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var confirmButton: some View {
        Button {
            print("Confirm flight booking")
            print("Airline: \(vm.airlineText)")
            print("Cabin: \(vm.cabinText)")
            print("Passengers: \(vm.passengerCountText)")
            print("Traveler: \(vm.firstName) \(vm.lastName)")
            print("Total: \(vm.totalText)")
        } label: {
            Text("Confirm Booking")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .fontWeight(.semibold)
        .disabled(!vm.canConfirm)
        .padding(.bottom, 8)
    }
    
    private func summaryRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
