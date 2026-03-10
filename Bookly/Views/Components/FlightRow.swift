//
//  FlightRow.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct FlightRow: View {
    let flight: Flight

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            topRow
            Divider()
            middleRow
            Divider()
            bottomRow
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }

    private var topRow: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.12))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "airplane")
                        .foregroundStyle(.blue)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(flight.airline?.airlineName ?? "Unknown Airline")
                    .font(.headline)

                Text(primaryCabinText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(priceText)
                .font(.title3)
                .fontWeight(.bold)
        }
    }

    private var middleRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(timeText(from: flight.departureTime))
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(airportDisplayName(flight.departureAirport))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 6) {
                Text(durationText)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 6) {
                    Circle()
                        .frame(width: 6, height: 6)

                    Rectangle()
                        .frame(width: 24, height: 1)

                    Image(systemName: "airplane")
                        .font(.caption)

                    Rectangle()
                        .frame(width: 24, height: 1)

                    Circle()
                        .frame(width: 6, height: 6)
                }
                .foregroundStyle(.secondary)

                Text("Flight")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(timeText(from: flight.arrivalTime))
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(airportDisplayName(flight.arrivalAirport))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var bottomRow: some View {
        HStack {
            Label(dateText, systemImage: "calendar")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text("View details")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
        }
    }
    
    private var primaryCabinText: String {
        cheapestCabin?.cabinClass ?? "Cabin not available"
    }
    
    private var priceText: String {
        guard let cabin = cheapestCabin else { return "N/A" }
        return String(format: "$%.0f", cabin.price)
    }
    
    private var durationText: String {
        let totalMinutes = Int(flight.duration) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    private var dateText: String {
        guard let departureTime = flight.departureTime else { return "Unknown date" }
        return departureTime.formatted(date: .abbreviated, time: .omitted)
    }
    
    private var cheapestCabin: Cabin? {
        let cabinsSet = flight.cabins as? Set<Cabin> ?? []
        return cabinsSet.sorted { $0.price < $1.price }.first
    }
    
    private func timeText(from date: Date?) -> String {
        guard let date else { return "--:--" }
        return date.formatted(date: .omitted, time: .shortened)
    }
    
    private func airportDisplayName(_ airport: Airport?) -> String {
        guard let airport else { return "Unknown airport" }
        
        let code = airport.code ?? ""
        let name = airport.name ?? "Unknown airport"
        
        return code.isEmpty ? name : code
    }
}
