//
//  FlightRow.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct FlightRow: View {
    @StateObject private var vm: FlightRowViewModel

    init(flight: Flight) {
        _vm = StateObject(wrappedValue: FlightRowViewModel(flight: flight))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            topRow
            Divider()
            middleRow
            Divider()
            cabinOptionsSection
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
                Text(vm.airlineText)
                    .font(.headline)

                Text("Available cabins")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    private var middleRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.departureTimeText)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(vm.departureAirportText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 6) {
                Text(vm.durationText)
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
                Text(vm.arrivalTimeText)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(vm.arrivalAirportText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var cabinOptionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(vm.cabins, id: \.objectID) { cabin in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(vm.cabinClassText(for: cabin))
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        Text(vm.cabinSeatsText(for: cabin))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(vm.cabinPriceText(for: cabin))
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var bottomRow: some View {
        HStack {
            Label(vm.dateText, systemImage: "calendar")
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
