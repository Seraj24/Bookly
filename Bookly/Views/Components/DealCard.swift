//
//  DealCard.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import SwiftUI

struct DealCard: View {
    let deal: Deal
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(deal.title)
                    .font(.headline)
                
                Text(deal.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Label(
                        String(format: "%.1f", deal.rating),
                        systemImage: "star.fill"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("$\(deal.pricePerNight)/night")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 2, y: 1)
    }
}
#Preview {
    DealCard(deal: ExampleDeals.sample[0])
}
