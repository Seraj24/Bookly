//
//  HotelDetailsViewModel.swift
//  Bookly
//
//  Created by user938962 on 3/8/26.
//

import Foundation
import Combine
import CoreData

final class HotelDetailsViewModel: ObservableObject {

    let hotel: Hotel
    
    private var authService = AuthService.shared
    
    @Published var checkInDate: Date
    @Published var checkOutDate: Date
    @Published var selectedRoom: Room?
    @Published var selectedQuantity: Int = 1
    
    init(hotel: Hotel, checkInDate: Date, checkOutDate: Date) {
        self.hotel = hotel
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate

    }
    
    var name: String {
        hotel.name ?? "Unknown Hotel"
    }

    var city: String {
        hotel.destination?.city ?? "Unknown City"
    }
    
    var address: String {
        hotel.hotelAddress ?? "Address not available"
    }

    var ratingText: String {
        String(format: "%.1f", hotel.rating)
    }

    var priceText: String {
        guard let price = selectedRoom?.price else {
            return "No room selected"
        }
        
        return String(format: "$%.0f", price)
    }
    
    var stayDurationText: String {
        let days = Calendar.current.dateComponents(
            [.day],
            from: checkInDate,
            to: checkOutDate
        ).day ?? 1
        
        return "\(days) night\(days == 1 ? "" : "s")"
        
    }
    
    var shortDescription: String {
        let description = hotel.hotelDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !description.isEmpty {
            return description
        }
        
        return "A comfortable stay in \(city), ideal for travelers looking for convenience and value."
    }
    
    var rooms: [Room] {
        return (hotel.rooms as? Set<Room>)?
            .sorted { $0.price < $1.price } ?? []
    }
    
    var canReserve: Bool {
        selectedRoom != nil
        
    }

    var maxSelectableQuantity: Int {
        Int(selectedRoom?.quantity ?? 1)
        
    }
    
    func refreshAuthState() {
        objectWillChange.send()
    }
    
    var isGuest: Bool {
        authService.isGuest || authService.currentUser == nil
        
    }

    var shouldShowSignInPrompt: Bool {
        isGuest
        
    }

    var signInPromptText: String {
        "You need to sign in before reserving a hotel."
        
    }

    var canProceedToBooking: Bool {
        !isGuest && selectedRoom != nil
        
    }

    func selectRoom(_ room: Room) {
        selectedRoom = room
        
        if selectedQuantity > Int(room.quantity) {
            selectedQuantity = Int(room.quantity)
        }
        
        if selectedQuantity < 1 {
            selectedQuantity = 1
        }
        
    }

    func increaseQuantity() {
        guard selectedQuantity < maxSelectableQuantity else { return }
        selectedQuantity += 1
        
    }

    func decreaseQuantity() {
        guard selectedQuantity > 1 else { return }
        selectedQuantity -= 1
        
    }

    func isSelected(_ room: Room) -> Bool {
        selectedRoom?.objectID == room.objectID
        
    }
}
