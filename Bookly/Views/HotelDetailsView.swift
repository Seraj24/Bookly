//
//  HotelDetailsView.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct HotelDetailsView: View {

    @StateObject private var vm: HotelDetailsViewModel

    init(vm: HotelDetailsViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                headerImage

                summaryCard

                detailsCard

                bookingCard
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Hotel Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerImage: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemGray5))
            .frame(height: 220)
            .overlay {
                Image(systemName: "building.2.crop.circle")
                    .font(.system(size: 42))
                    .foregroundStyle(.secondary)
            }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                VStack(alignment: .leading) {
                    Text(vm.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    Label(vm.city, systemImage: "mappin.and.ellipse")
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                    Text(vm.ratingText)
                }
                .font(.subheadline)
                .padding(8)
                .background(Color.yellow.opacity(0.15))
                .clipShape(Capsule())
            }

            Divider()

            Text(vm.shortDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var detailsCard: some View {
        VStack(spacing: 12) {

            detailsRow(
                title: "Price",
                value: vm.priceText,
                systemImage: "dollarsign.circle"
            )

            Divider()

            detailsRow(
                title: "Rating",
                value: vm.ratingText,
                systemImage: "star"
            )

            Divider()

            detailsRow(
                title: "Location",
                value: vm.city,
                systemImage: "location"
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var bookingCard: some View {
        Button {
            print("Reserve tapped")
        } label: {
            Text("Reserve Now")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .fontWeight(.semibold)
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
        }
    }
}
