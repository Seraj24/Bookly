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
                
                roomType

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
            
            Divider()
            
            detailsRow(
                title: "Address",
                value: vm.address,
                systemImage: "mappin"
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var roomType: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Select Room")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                ForEach(vm.rooms, id: \.objectID) { room in
                    roomCard(room)
                }

                if let selectedRoom = vm.selectedRoom {
                    quantityCard(for: selectedRoom)
                }
            }
        }

        private func roomCard(_ room: Room) -> some View {
            
            SelectionOptionCard(
                    title: (room.roomType ?? "Unknown Room").capitalized,
                    subtitle: "Available rooms: \(room.quantity)",
                    priceText: String(format: "$%.0f", room.price),
                    priceCaption: "1 night",
                    benefits: [
                        OptionBenefit(
                            text: "Free cancellation",
                            systemImage: "checkmark.circle.fill",
                            color: .green
                        ),
                        OptionBenefit(
                            text: "No prepayment needed",
                            systemImage: "checkmark.circle.fill",
                            color: .green
                        ),
                        OptionBenefit(
                            text: "Sleeps 2 guests",
                            systemImage: "person.2.fill",
                            color: .secondary
                        )
                    ],
                    isSelected: vm.isSelected(room),
                    actionTitle: vm.isSelected(room) ? "Selected" : "Select",
                    onSelect: {
                        vm.selectRoom(room)
                    }
                )
        }

    private func quantityCard(for room: Room) -> some View {
        QuantitySelectorCard(
            title: "Room Quantity",
            subtitle: "Selected room: \((room.roomType ?? "Unknown Room").capitalized)",
            value: vm.selectedQuantity,
            availabilityText: "Available: \(room.quantity)",
            canDecrease: vm.selectedQuantity > 1,
            canIncrease: vm.selectedQuantity < vm.maxSelectableQuantity,
            onDecrease: {
                vm.decreaseQuantity()
            },
            onIncrease: {
                vm.increaseQuantity()
            }
        )
    }

    private var bookingCard: some View {
        VStack(spacing: 12) {
            if vm.shouldShowSignInPrompt {
                VStack(spacing: 12) {
                    Text(vm.signInPromptText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .fontWeight(.semibold)
                }
            } else if let selectedRoom = vm.selectedRoom {
                HStack {
                    Text("Selected")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\((selectedRoom.roomType ?? "Unknown Room").capitalized) × \(vm.selectedQuantity)")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)

                NavigationLink {
                    HotelBookingView(
                        vm: HotelBookingViewModel(
                            selection: HotelBookingSelection(
                                hotel: vm.hotel,
                                room: selectedRoom,
                                quantity: vm.selectedQuantity
                            )
                        )
                    )
                } label: {
                    Text("Reserve Now")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.semibold)
                .disabled(!vm.canProceedToBooking)
            } else {
                Button {
                } label: {
                    Text("Reserve Now")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .fontWeight(.semibold)
                .disabled(true)
            }
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
