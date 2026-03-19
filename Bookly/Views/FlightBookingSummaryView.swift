//
//  FlightBookingSummaryView.swift
//  Bookly
//
//  Created by user938962 on 3/19/26.
//

import SwiftUI

struct FlightBookingSummaryView: View {
    
    let booking: FlightBooking
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
            
            Text(booking.airlineName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(errorMessage ?? "Your flight booking was created successfully.")
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
            detailRow("Airline", booking.airlineName)
            Divider()
            detailRow("Route", "\(booking.departureCode) → \(booking.arrivalCode)")
            Divider()
            detailRow("Cabin", booking.cabinClass)
            Divider()
            detailRow("Passengers", "\(booking.passengerCount)")
            Divider()
            detailRow("Guest", "\(booking.guestFirstName) \(booking.guestLastName)")
            Divider()
            detailRow("Status", booking.status.rawValue.capitalized)
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
