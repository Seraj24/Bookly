//
//  HomeViewModel.swift
//  Bookly
//
//  Created by user938962 on 2/8/26.
//

import Foundation
import Combine
import CoreData

enum TripType: String, CaseIterable {
    case oneWay = "One-way"
    case roundTrip = "Round trip"
}

final class HomeViewModel: ObservableObject {
    @Published var selectedCategory: Category = .hotels
    @Published var route: HomeRoute? = nil
    
    @Published private(set) var destinations: [HomeDestinationItem] = []
    @Published private(set) var popularHotels: [HomeHotelItem] = []
    
    private var holder: BooklyHolder?
    private var context: NSManagedObjectContext?
    
    func configure(holder: BooklyHolder, context: NSManagedObjectContext) {
        self.holder = holder
        self.context = context
        reloadHomeSections()
    }
    
    func reloadHomeSections() {
        guard let holder else { return }
        
        destinations = holder.destinations.compactMap { destination -> HomeDestinationItem? in
            guard
                let id = destination.id,
                let city = destination.city,
                let country = destination.country
            else {
                return nil
            }
            
            return HomeDestinationItem(
                id: id,
                destination: destination,
                title: city,
                country: country,
                description: destinationDescription(for: city),
                imageURL: destinationImageURL(for: city)
            )
        }
        
        popularHotels = holder.hotels
            .sorted { lhs, rhs in
                if lhs.rating == rhs.rating {
                    return (lhs.name ?? "") < (rhs.name ?? "")
                }
                return lhs.rating > rhs.rating
            }
            .prefix(8)
            .compactMap { hotel -> HomeHotelItem? in
                guard
                    let id = hotel.id,
                    let name = hotel.name,
                    let address = hotel.hotelAddress
                else {
                    return nil
                }
                
                return HomeHotelItem(
                    id: id,
                    hotel: hotel,
                    name: name,
                    address: address,
                    rating: hotel.rating,
                    imageURL: url(from: hotel.photoURL),
                    destinationTitle: hotel.destination?.city ?? "Unknown"
                )
            }
    }
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func showHotels(request: HotelSearchRequest) {
        route = .hotels(request: request)
    }
    
    func showFlights(request: FlightSearchRequest) {
        route = .flights(request: request)
    }
    
    func showHotelDetails(_ hotel: Hotel) {
        let calendar = Calendar.current
        let checkIn = calendar.startOfDay(for: Date())
        let checkOut = calendar.date(byAdding: .day, value: 1, to: checkIn) ?? checkIn
        
        let request = HotelSearchRequest(
            destination: hotel.destination?.city ?? "",
            checkInDate: checkIn,
            checkOutDate: checkOut
        )
        
        route = .hotelDetails(hotel: hotel, request: request)
    }
    
    func showDestinationMap() {
        route = .destinationMap(selectedDestination: nil)
    }

    func showDestinationOnMap(_ destination: Destination) {
        route = .destinationMap(selectedDestination: destination)
    }
    
    private func url(from string: String?) -> URL? {
        guard let string, !string.isEmpty else { return nil }
        return URL(string: string)
    }
    
    private func destinationDescription(for city: String) -> String {
        switch city.lowercased() {
        case "montreal":
            return "Historic streets, modern skyline, and a vibrant cultural scene."
        case "barcelona":
            return "Sunny coastlines, bold architecture, and lively Mediterranean energy."
        case "toronto":
            return "A polished skyline, urban culture, and iconic downtown views."
        case "vancouver":
            return "Oceanfront city life framed by mountains and natural beauty."
        case "paris":
            return "Romantic boulevards, timeless landmarks, and elegant city views."
        case "london":
            return "Historic charm, modern city life, and iconic riverside landmarks."
        case "dubai":
            return "Luxury towers, desert warmth, and dramatic modern architecture."
        case "new york":
            return "Fast-paced energy, towering skylines, and unforgettable city streets."
        default:
            return "Explore unforgettable stays, landmarks, and local experiences."
        }
    }
    
    private func destinationImageURL(for city: String) -> URL? {
        switch city.lowercased() {
        case "montreal":
            return URL(string: "https://images.pexels.com/photos/26864265/pexels-photo-26864265.jpeg?cs=srgb&dl=pexels-eloimotte-26864265.jpg&fm=jpg")
        case "barcelona":
            return URL(string: "https://images.pexels.com/photos/1388030/pexels-photo-1388030.jpeg")
        case "toronto":
            return URL(string: "https://images.pexels.com/photos/374870/pexels-photo-374870.jpeg")
        case "vancouver":
            return URL(string: "https://images.pexels.com/photos/35788149/pexels-photo-35788149.jpeg?auto=compress&cs=tinysrgb&w=800")
        case "paris":
            return URL(string: "https://images.pexels.com/photos/34773158/pexels-photo-34773158.jpeg?cs=srgb&dl=pexels-solce-34773158.jpg&fm=jpg")
        case "london":
            return URL(string: "https://images.pexels.com/photos/460672/pexels-photo-460672.jpeg")
        case "dubai":
            return URL(string: "https://images.pexels.com/photos/3787839/pexels-photo-3787839.jpeg")
        case "new york":
            return URL(string: "https://images.pexels.com/photos/802024/pexels-photo-802024.jpeg")
        default:
            return nil
        }
    }
}
    
