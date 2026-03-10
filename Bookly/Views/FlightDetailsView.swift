//
//  FlightDetailsView.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct FlightDetailsView: View {
    let flight: Flight
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                routeCard
                detailsCard
                bookingCard
            }
            .padding()
        }
        .navigationTitle("Flight Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
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
            
            Divider()
            
            Text("A clean and comfortable option for your trip.")
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
                    Text(flight.departureTime)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(flight.fromCity)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 6) {
                    Text(flight.duration)
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
                    
                    Text(flight.stopsText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: 120)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(flight.arrivalTime)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(flight.toCity)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                Label("Date", systemImage: "calendar")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(flight.date)
                    .foregroundStyle(.primary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var detailsCard: some View {
        VStack(spacing: 14) {
            detailsRow(title: "Airline", value: flight.airline, systemImage: "building.2")
            Divider()
            detailsRow(title: "Cabin", value: flight.cabin, systemImage: "seat.side.right")
            Divider()
            detailsRow(title: "Duration", value: flight.duration, systemImage: "clock")
            Divider()
            detailsRow(title: "Stops", value: flight.stopsText, systemImage: "point.topleft.down.curvedto.point.bottomright.up")
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var bookingCard: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Price")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("$\(flight.price)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
            
            Button {
                print("Book flight tapped")
            } label: {
                Text("Book Flight")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .fontWeight(.semibold)
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

#Preview {
    //FlightDetailsView()
}
