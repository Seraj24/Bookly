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
                Text(flight.airline)
                    .font(.headline)

                Text(flight.cabin)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("$\(flight.price)")
                .font(.title3)
                .fontWeight(.bold)
        }
    }

    private var middleRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(flight.departureTime)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(flight.fromCity)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 6) {
                Text(flight.duration)
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

                Text(flight.stopsText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(flight.arrivalTime)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(flight.toCity)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var bottomRow: some View {
        HStack {
            Label(flight.date, systemImage: "calendar")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text("View details")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
        }
    }
}
#Preview {
    //FlightRow(nil)
}
