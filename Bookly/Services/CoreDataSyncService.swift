//
//  CoreDataSyncService.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation
import CoreData

final class CoreDataSyncService {
    static let shared = CoreDataSyncService()

    private init() {}

    func syncAll(
        _ remoteData: BooklyRemoteData,
        into context: NSManagedObjectContext
    ) async throws {
        try await context.perform {

            for dto in remoteData.destinations {
                self.upsertDestination(dto, into: context)
            }

            for dto in remoteData.airlines {
                self.upsertAirline(dto, into: context)
            }


            for dto in remoteData.airports {
                self.upsertAirport(dto, into: context)
            }

            for dto in remoteData.hotels {
                self.upsertHotel(dto, into: context)
            }


            for dto in remoteData.rooms {
                self.upsertRoom(dto, into: context)
            }

            for dto in remoteData.flights {
                self.upsertFlight(dto, into: context)
            }

            for dto in remoteData.cabins {
                self.upsertCabin(dto, into: context)
            }

            if context.hasChanges {
                try context.save()
            }
        }
    }

    // MARK: - Upsert Methods

    @discardableResult
    private func upsertDestination(
        _ dto: DestinationDocument,
        into context: NSManagedObjectContext
    ) -> Destination {
        let object = fetchOrCreateDestination(id: dto.id, in: context)
        object.id = uuid(from: dto.id)
        object.city = dto.city
        object.country = dto.country
        return object
    }

    @discardableResult
    private func upsertAirline(
        _ dto: AirlineDocument,
        into context: NSManagedObjectContext
    ) -> Airline {
        let object = fetchOrCreateAirline(id: dto.id, in: context)
        object.id = uuid(from: dto.id)
        object.airlineName = dto.airlineName
        return object
    }

    @discardableResult
    private func upsertAirport(
        _ dto: AirportDocument,
        into context: NSManagedObjectContext
    ) -> Airport {
        let object = fetchOrCreateAirport(id: dto.id, in: context)
        object.id = uuid(from: dto.id)
        object.name = dto.name
        object.code = dto.code

        if let destination = fetchDestination(id: dto.destinationId, in: context) {
            object.destination = destination
        }

        object.setValue(dto.latitude, forKey: "latitude")
        object.setValue(dto.longitude, forKey: "longitude")

        return object
    }

    @discardableResult
    private func upsertHotel(
        _ dto: HotelDocument,
        into context: NSManagedObjectContext
    ) -> Hotel {
        let object = fetchOrCreateHotel(id: dto.id, in: context)
        object.id = uuid(from: dto.id)
        object.name = dto.name
        object.hotelAddress = dto.hotelAddress
        object.hotelDescription = dto.hotelDescription
        object.rating = Float(dto.rating)

        if let destination = fetchDestination(id: dto.destinationId, in: context) {
            object.destination = destination
        }

        object.setValue(dto.latitude, forKey: "latitude")
        object.setValue(dto.longitude, forKey: "longitude")
        object.setValue(dto.photoURL, forKey: "photoURL")

        return object
    }

    @discardableResult
    private func upsertRoom(
        _ dto: RoomDocument,
        into context: NSManagedObjectContext
    ) -> Room {
        let object = fetchOrCreateRoom(id: dto.id, in: context)
        object.id = uuid(from: dto.id)
        object.roomType = dto.roomType
        object.price = dto.price
        object.quantity = dto.quantity

        if let hotel = fetchHotel(id: dto.hotelId, in: context) {
            object.hotel = hotel
        }

        return object
    }

    @discardableResult
    private func upsertFlight(
        _ dto: FlightDocument,
        into context: NSManagedObjectContext
    ) -> Flight {
        let object = fetchOrCreateFlight(id: dto.id, in: context)
        object.id = uuid(from: dto.id)
        object.flightNumber = dto.flightNumber
        object.departureTime = dto.departureTime
        object.arrivalTime = dto.arrivalTime
        object.duration = dto.duration

        if let airline = fetchAirline(id: dto.airlineId, in: context) {
            object.airline = airline
        }

        if let departureAirport = fetchAirport(id: dto.fromAirportId, in: context) {
            object.departureAirport = departureAirport
        }

        if let arrivalAirport = fetchAirport(id: dto.toAirportId, in: context) {
            object.arrivalAirport = arrivalAirport
        }

        return object
    }

    @discardableResult
    private func upsertCabin(
        _ dto: CabinDocument,
        into context: NSManagedObjectContext
    ) -> Cabin {
        let object = fetchOrCreateCabin(id: dto.id, in: context)
        object.id = uuid(from: dto.id)
        object.cabinClass = dto.cabinClass
        object.price = dto.price
        object.remainingSeats = dto.remainingSeats

        if let flight = fetchFlight(id: dto.flightId, in: context) {
            object.flight = flight
        }

        return object
    }

    // MARK: - Fetch Existing

    private func fetchDestination(id: String, in context: NSManagedObjectContext) -> Destination? {
        let request: NSFetchRequest<Destination> = Destination.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", uuid(from: id) as CVarArg)
        return try? context.fetch(request).first
    }

    private func fetchAirline(id: String, in context: NSManagedObjectContext) -> Airline? {
        let request: NSFetchRequest<Airline> = Airline.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", uuid(from: id) as CVarArg)
        return try? context.fetch(request).first
    }

    private func fetchAirport(id: String, in context: NSManagedObjectContext) -> Airport? {
        let request: NSFetchRequest<Airport> = Airport.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", uuid(from: id) as CVarArg)
        return try? context.fetch(request).first
    }

    private func fetchHotel(id: String, in context: NSManagedObjectContext) -> Hotel? {
        let request: NSFetchRequest<Hotel> = Hotel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", uuid(from: id) as CVarArg)
        return try? context.fetch(request).first
    }

    private func fetchRoom(id: String, in context: NSManagedObjectContext) -> Room? {
        let request: NSFetchRequest<Room> = Room.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", uuid(from: id) as CVarArg)
        return try? context.fetch(request).first
    }

    private func fetchFlight(id: String, in context: NSManagedObjectContext) -> Flight? {
        let request: NSFetchRequest<Flight> = Flight.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", uuid(from: id) as CVarArg)
        return try? context.fetch(request).first
    }

    private func fetchCabin(id: String, in context: NSManagedObjectContext) -> Cabin? {
        let request: NSFetchRequest<Cabin> = Cabin.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", uuid(from: id) as CVarArg)
        return try? context.fetch(request).first
    }

    // MARK: - Fetch or Create

    private func fetchOrCreateDestination(id: String, in context: NSManagedObjectContext) -> Destination {
        fetchDestination(id: id, in: context) ?? Destination(context: context)
    }

    private func fetchOrCreateAirline(id: String, in context: NSManagedObjectContext) -> Airline {
        fetchAirline(id: id, in: context) ?? Airline(context: context)
    }

    private func fetchOrCreateAirport(id: String, in context: NSManagedObjectContext) -> Airport {
        fetchAirport(id: id, in: context) ?? Airport(context: context)
    }

    private func fetchOrCreateHotel(id: String, in context: NSManagedObjectContext) -> Hotel {
        fetchHotel(id: id, in: context) ?? Hotel(context: context)
    }

    private func fetchOrCreateRoom(id: String, in context: NSManagedObjectContext) -> Room {
        fetchRoom(id: id, in: context) ?? Room(context: context)
    }

    private func fetchOrCreateFlight(id: String, in context: NSManagedObjectContext) -> Flight {
        fetchFlight(id: id, in: context) ?? Flight(context: context)
    }

    private func fetchOrCreateCabin(id: String, in context: NSManagedObjectContext) -> Cabin {
        fetchCabin(id: id, in: context) ?? Cabin(context: context)
    }

    // MARK: - Helpers

    private func uuid(from string: String) -> UUID {
        UUID(uuidString: string) ?? UUID()
    }
}
