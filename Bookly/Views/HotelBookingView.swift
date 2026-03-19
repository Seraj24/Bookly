//
//  HotelBookingView.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import SwiftUI

struct HotelBookingView: View {
    
    @StateObject private var vm: HotelBookingViewModel
    
    init(vm: HotelBookingViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                hotelSummaryCard
                stayDetailsCard
                guestDetailsCard
                priceSummaryCard
                confirmButton
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Booking")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var hotelSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(vm.hotelName)
                .font(.title3)
                .fontWeight(.bold)
            
            Label(vm.cityText, systemImage: "mappin.and.ellipse")
                .foregroundStyle(.secondary)
            
            Text(vm.addressText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Divider()
            
            HStack {
                Text("Room")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(vm.roomTypeText)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("Quantity")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(vm.quantityText)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var stayDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stay Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            DatePicker("Check-in", selection: $vm.checkInDate, displayedComponents: .date)
            DatePicker("Check-out", selection: $vm.checkOutDate, in: vm.checkInDate..., displayedComponents: .date)
            
            HStack {
                Text("Nights")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("\(vm.nightsCount)")
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var guestDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Guest Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("First Name", text: $vm.guestFirstName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Last Name", text: $vm.guestLastName)
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
    
    private var priceSummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Price Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            summaryRow("Price per night", String(format: "$%.0f", vm.pricePerNight))
            summaryRow("Rooms × nights", "\(vm.selection.quantity) × \(vm.nightsCount)")
            summaryRow("Subtotal", vm.subtotalText)
            summaryRow("Taxes & fees", vm.taxesText)
            
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
            print("Confirm hotel booking")
            print("Hotel: \(vm.hotelName)")
            print("Room: \(vm.roomTypeText)")
            print("Quantity: \(vm.selection.quantity)")
            print("Check-in: \(vm.checkInDate)")
            print("Check-out: \(vm.checkOutDate)")
            print("Guest: \(vm.guestFirstName) \(vm.guestLastName)")
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
