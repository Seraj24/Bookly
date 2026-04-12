//
//  PopularHotelCard.swift
//  Bookly
//
//  Created by user938962 on 4/12/26.
//

import SwiftUI

struct PopularHotelCard: View {
    let item: HomeHotelItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.systemGray5))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.systemGray5))
                        Image(systemName: "building.2.crop.circle")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                @unknown default:
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemGray5))
                }
            }
            .frame(width: 220, height: 145)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(item.destinationTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    
                    Text(String(format: "%.1f", item.rating))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Text(item.address)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 2)
        }
        .frame(width: 220, alignment: .leading)
    }
}

