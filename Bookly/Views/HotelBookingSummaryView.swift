//
//  HotelBookingSummaryView.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import SwiftUI

struct HotelBookingSummaryView: View {
    
    let booking: HotelBooking
    let errorMessage: String?
    
    private var isSuccess: Bool {
        errorMessage == nil
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                statusCard
                detailsCard
                totalCard
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Booking Summary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var statusCard: some View {
        VStack(spacing: 12) {
            Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(isSuccess ? .green : .red)
            
            Text(isSuccess ? "Booking Confirmed" : "Booking Failed")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(booking.hotelName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(errorMessage ?? "Your hotel booking was created successfully.")
                .font(.subheadline)
                .foregroundStyle(isSuccess ? .green : .red)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            detailRow("Hotel", booking.hotelName)
            Divider()
            detailRow("City", booking.city)
            Divider()
            detailRow("Room", booking.roomType)
            Divider()
            detailRow("Quantity", "\(booking.quantity)")
            Divider()
            detailRow("Check-in", booking.checkInDate.formatted(date: .abbreviated, time: .omitted))
            Divider()
            detailRow("Check-out", booking.checkOutDate.formatted(date: .abbreviated, time: .omitted))
            Divider()
            detailRow("Guest", "\(booking.guestFirstName) \(booking.guestLastName)")
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var totalCard: some View {
        HStack {
            Text("Total")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            Text(String(format: "$%.0f", booking.total))
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func detailRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
    }
}
