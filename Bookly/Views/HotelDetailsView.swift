//
//  HotelDetailsView.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import SwiftUI

struct HotelDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm: HotelDetailsViewModel
    @ObservedObject private var auth = AuthService.shared

    init(hotel: Hotel, request: HotelSearchRequest) {
        _vm = StateObject(
            wrappedValue: HotelDetailsViewModel(
                hotel: hotel,
                checkInDate: request.checkInDate,
                checkOutDate: request.checkOutDate
            )
        )
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
        .onChange(of: auth.currentUser?.id) { _ in
            vm.refreshAuthState()
        }
    }
    
    private var headerImage: some View {
        Group {
            if let urlString = vm.hotel.photoURL,
               let url = URL(string: urlString) {
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color(.systemGray5)
                            ProgressView()
                        }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .failure(let error):
                        ZStack {
                            Color(.systemGray5)
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.title2)
                                Text("Failed to load image")
                                    .font(.caption)
                                Text(error.localizedDescription)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                        
                    @unknown default:
                        fallbackImage
                    }
                }
            } else {
                fallbackImage
            }
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var fallbackImage: some View {
        ZStack {
            Color(.systemGray5)

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
            
            Divider()
            
            detailsRow(
                title: "Check-in",
                value: vm.checkInDate.formatted(date: .abbreviated, time: .omitted),
                systemImage: "calendar"
            )
            
            Divider()
            
            detailsRow(
                title: "Check-out",
                value: vm.checkOutDate.formatted(date: .abbreviated, time: .omitted),
                systemImage: "calendar"
            )
            
            Divider()
            
            detailsRow(
                title: "Stay",
                value: vm.stayDurationText,
                systemImage: "moon"
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
                                quantity: vm.selectedQuantity,
                                checkIn: vm.checkInDate,
                                checkOut: vm.checkOutDate
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
