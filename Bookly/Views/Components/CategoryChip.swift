//
//  CategoryChip.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct CategoryChip: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                iconBadge
                title
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .background(backgroundStyle)
            .overlay(borderStyle)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(
                color: isSelected
                    ? Color("PrimaryColor").opacity(0.18)
                    : Color.black.opacity(0.04),
                radius: isSelected ? 12 : 4,
                y: isSelected ? 6 : 2
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(duration: 0.25), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    private var iconBadge: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    isSelected
                    ? Color.white.opacity(0.22)
                    : Color("PrimaryColor").opacity(0.10)
                )
                .frame(width: 34, height: 34)

            Image(systemName: category.icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isSelected ? Color.white : Color("PrimaryColor"))
        }
    }

    private var title: some View {
        Text(category.title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(isSelected ? Color.white : Color.primary)
    }

    private var backgroundStyle: some ShapeStyle {
        if isSelected {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color("PrimaryColor"),
                        Color("PrimaryColor").opacity(0.82)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        } else {
            return AnyShapeStyle(Color.white.opacity(0.96))
        }
    }

    private var borderStyle: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(
                isSelected
                ? Color.white.opacity(0.16)
                : Color.black.opacity(0.06),
                lineWidth: 1
            )
    }
}

#Preview {
    //CategoryChip()
}
