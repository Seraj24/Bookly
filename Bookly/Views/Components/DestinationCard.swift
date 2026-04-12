//
//  DestinationCard.swift
//  Bookly
//
//  Created by user938962 on 4/12/26.
//

import SwiftUI

struct DestinationCard: View {
    let item: HomeDestinationItem
    
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
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                @unknown default:
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemGray5))
                }
            }
            .frame(width: 260, height: 170)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                Text(item.country)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 2)
        }
        .frame(width: 260, alignment: .leading)
    }
}
