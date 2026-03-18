//
//  SelectionOptionCard.swift
//  Bookly
//
//  Created by user938962 on 3/18/26.
//

import SwiftUI

struct SelectionOptionCard: View {
    
    let title: String
    let subtitle: String
    let priceText: String
    let priceCaption: String
    let benefits: [OptionBenefit]
    let isSelected: Bool
    let actionTitle: String
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(priceText)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(priceCaption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(benefits) { benefit in
                    Label(benefit.text, systemImage: benefit.systemImage)
                        .font(.subheadline)
                        .foregroundColor(benefit.color)
                }
            }
            
            Button(action: onSelect) {
                Text(actionTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSelected ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct OptionBenefit: Identifiable {
    let id = UUID()
    let text: String
    let systemImage: String
    let color: Color
}
