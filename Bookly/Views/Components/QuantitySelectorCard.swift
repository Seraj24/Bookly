//
//  QuantitySelectorCard.swift
//  Bookly
//
//  Created by user938962 on 3/18/26.
//

import SwiftUI

struct QuantitySelectorCard: View {
    
    let title: String
    let subtitle: String
    let value: Int
    let availabilityText: String
    let canDecrease: Bool
    let canIncrease: Bool
    let onDecrease: () -> Void
    let onIncrease: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Button(action: onDecrease) {
                    Image(systemName: "minus")
                        .frame(width: 36, height: 36)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .disabled(!canDecrease)
                
                Spacer()
                
                Text("\(value)")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: onIncrease) {
                    Image(systemName: "plus")
                        .frame(width: 36, height: 36)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .disabled(!canIncrease)
            }
            
            Text(availabilityText)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}
