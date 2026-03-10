//
//  SearchView.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import SwiftUI

struct SearchView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                headerSection
                
                HStack(spacing: 16) {
                    NavigationLink {
                        HotelSearchView { _ in }
                    } label: {
                        searchCategoryCard(
                            title: "Hotels",
                            subtitle: "Find stays, rooms, and destination deals.",
                            icon: "bed.double.fill"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    NavigationLink {
                        FlightSearchView { _ in }
                    } label: {
                        searchCategoryCard(
                            title: "Flights",
                            subtitle: "Compare routes, dates, and flight options.",
                            icon: "airplane"
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Color("BackgroundColor"))
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Search")
                .font(.system(size: 30, weight: .bold))
            
            Text("Choose what you want to search for.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func searchCategoryCard(title: String, subtitle: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color("PrimaryColor"))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("PrimaryColor"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
        .background(Color("CardColor").opacity(0.96))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }
}


#Preview {
    SearchView()
}
