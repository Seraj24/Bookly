//
//  HotelsView.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import SwiftUI

struct HotelsView: View {
    
    let destination: String
    
    @StateObject private var vm: HotelsViewModel
    
    init(destination: String) {
        self.destination = destination
        _vm = StateObject(wrappedValue: HotelsViewModel(destination: destination))
    }
    
    var body: some View {
        List {
            if vm.hotels.isEmpty {
                ContentUnavailableView(
                    "No hotels found",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different city.")
                )
            } else {
                Section("Results in \(destination.isEmpty ? "All Cities" : destination)") {
                    ForEach(vm.hotels) { hotel in
                        HotelRow(hotel: hotel)
                    }
                }
            }
        }
        .navigationTitle("Hotels")
        .navigationBarTitleDisplayMode(.inline)
    }

    private struct HotelRow: View {
        
        let hotel: Hotel

        var body: some View {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "building.2")
                            .foregroundStyle(.secondary)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(hotel.name)
                        .font(.headline)

                    Text(hotel.city)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Label(String(format: "%.1f", hotel.rating), systemImage: "star.fill")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("$\(hotel.pricePerNight)/night")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    HotelsView(destination: "Montreal")
}
