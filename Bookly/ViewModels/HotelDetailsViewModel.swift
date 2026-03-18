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

    private let hotel: Hotel
    
    @Published var selectedRoom: Room?
    @Published var selectedQuantity: Int = 1
    
    init(hotel: Hotel) {
        self.hotel = hotel
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
        if hotel.responds(to: Selector(("pricePerNight"))) {
            return "Price unavailable"
        } else {
            return "Price unavailable"
        }
    }

    var shortDescription: String {
        let description = hotel.hotelDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !description.isEmpty {
            return description
        }
        
        return "A comfortable stay in \(city), ideal for travelers looking for convenience and value."
    }
    
    var rooms: [Room] {
        
        return (hotel.rooms as? Set<Room>)?.sorted { $0.roomType ?? "" < $1.roomType ?? "" } ?? []
    }
    
    var canReserve: Bool {
        selectedRoom != nil
        
    }

    var maxSelectableQuantity: Int {
        Int(selectedRoom?.quantity ?? 1)
        
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
