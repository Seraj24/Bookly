//
//  HotelsView.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import SwiftUI

struct HotelsResultsView: View {
    
    let destination: String
    
    @EnvironmentObject private var holder: BooklyHolder
    
    @StateObject private var vm: HotelsResultsViewModel
    
    init(destination: String) {
        self.destination = destination
        _vm = StateObject(wrappedValue: HotelsResultsViewModel(destination: destination))
        
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
                        
                        NavigationLink {
                            HotelDetailsView(
                                vm: HotelDetailsViewModel(hotel: hotel)
                            )
                        } label: {
                            HotelRow(hotel: hotel)
                        }
                        .buttonStyle(.plain)
                        
                    }
                    
                }
            }
        }
        .navigationTitle("Hotels")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.setHotels(holder.hotels, destination: destination)
        }
    }
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
                
                Text(hotel.name ?? "Unknown Hotel")
                    .font(.headline)
                
                Text(hotel.destination?.city ?? "Unknown City")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Label(
                        String(format: "%.1f", hotel.rating),
                        systemImage: "star.fill"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    /*
    HotelsResultsView(destination: "Montreal")
        .environmentObject(BooklyHolder(PersistenceController.shared.container.viewContext))
     */
}
