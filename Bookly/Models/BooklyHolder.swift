//
//  BooklyHolder.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import Foundation
import Combine
import CoreData

final class BooklyHolder: ObservableObject {
    
    // MARK: - UI State
    @Published var selectedDestination: Destination? = nil
    @Published var selectedAirline: Airline? = nil
    @Published var searchText: String = ""
    
    // MARK: - Published Data
    @Published var airlines: [Airline] = []
    @Published var airports: [Airport] = []
    @Published var users: [AppUser] = []
    @Published var cabins: [Cabin] = []
    @Published var destinations: [Destination] = []
    @Published var flights: [Flight] = []
    @Published var hotels: [Hotel] = []
    @Published var rooms: [Room] = []
    
    init(_ context: NSManagedObjectContext) {
        //BooklySeeder.seedIfNeeded(context)
        refreshAll(context)
    }
    
    // MARK: - Refresh
    func refreshAll(_ context: NSManagedObjectContext) {
        refreshAirlines(context)
        refreshAirports(context)
        refreshUsers(context)
        refreshCabins(context)
        refreshDestinations(context)
        refreshFlights(context)
        refreshHotels(context)
        refreshRooms(context)
    }
    
    func refreshAirlines(_ context: NSManagedObjectContext) {
        airlines = fetchAirlines(context)
    }
    
    func refreshAirports(_ context: NSManagedObjectContext) {
        airports = fetchAirports(context)
    }
    
    func refreshUsers(_ context: NSManagedObjectContext) {
        users = fetchUsers(context)
    }
    
    func refreshCabins(_ context: NSManagedObjectContext) {
        cabins = fetchCabins(context)
    }
    
    func refreshDestinations(_ context: NSManagedObjectContext) {
        destinations = fetchDestinations(context)
    }
    
    func refreshFlights(_ context: NSManagedObjectContext) {
        flights = fetchFlights(context)
    }
    
    func refreshHotels(_ context: NSManagedObjectContext) {
        hotels = fetchHotels(context)
    }
    
    func refreshRooms(_ context: NSManagedObjectContext) {
        rooms = fetchRooms(context)
    }
    
    // MARK: - Fetchers
    func fetchAirlines(_ context: NSManagedObjectContext) -> [Airline] {
        do { return try context.fetch(airlinesFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchAirports(_ context: NSManagedObjectContext) -> [Airport] {
        do { return try context.fetch(airportsFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchUsers(_ context: NSManagedObjectContext) -> [AppUser] {
        do { return try context.fetch(usersFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchCabins(_ context: NSManagedObjectContext) -> [Cabin] {
        do { return try context.fetch(cabinsFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchDestinations(_ context: NSManagedObjectContext) -> [Destination] {
        do { return try context.fetch(destinationsFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchFlights(_ context: NSManagedObjectContext) -> [Flight] {
        do { return try context.fetch(flightsFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchHotels(_ context: NSManagedObjectContext) -> [Hotel] {
        do { return try context.fetch(hotelsFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchFlights(for airline: Airline, _ context: NSManagedObjectContext) -> [Flight] {
        do { return try context.fetch(flightsByAirlineFetch(for: airline)) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchFlights(for destination: Destination, _ context: NSManagedObjectContext) -> [Flight] {
        do { return try context.fetch(flightsByDestinationFetch(for: destination)) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchHotels(for destination: Destination, _ context: NSManagedObjectContext) -> [Hotel] {
        do { return try context.fetch(hotelsByDestinationFetch(for: destination)) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchCabins(for flight: Flight, _ context: NSManagedObjectContext) -> [Cabin] {
        do { return try context.fetch(cabinsByFlightFetch(for: flight)) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchRooms(_ context: NSManagedObjectContext) -> [Room] {
        do { return try context.fetch(roomsFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    // MARK: - Fetch Requests
    func airlinesFetch() -> NSFetchRequest<Airline> {
        let request = Airline.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Airline.airlineName, ascending: true)
        ]
        return request
    }
    
    func airportsFetch() -> NSFetchRequest<Airport> {
        let request = Airport.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Airport.name, ascending: true)
        ]
        return request
    }
    
    func usersFetch() -> NSFetchRequest<AppUser> {
        let request = AppUser.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \AppUser.firstName, ascending: true),
            NSSortDescriptor(keyPath: \AppUser.lastName, ascending: true)
        ]
        return request
    }
    
    func cabinsFetch() -> NSFetchRequest<Cabin> {
        let request = Cabin.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Cabin.price, ascending: true)
        ]
        return request
    }
    
    func destinationsFetch() -> NSFetchRequest<Destination> {
        let request = Destination.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Destination.city, ascending: true),
            NSSortDescriptor(keyPath: \Destination.country, ascending: true)
        ]
        return request
    }
    
    func flightsFetch() -> NSFetchRequest<Flight> {
        let request = Flight.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Flight.departureTime, ascending: true),
            NSSortDescriptor(keyPath: \Flight.flightNumber, ascending: true)
        ]
        
        request.predicate = flightsPredicate()
        return request
    }
    
    func hotelsFetch() -> NSFetchRequest<Hotel> {
        let request = Hotel.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Hotel.name, ascending: true)
        ]
        
        request.predicate = hotelsPredicate()
        return request
    }
    
    func roomsFetch() -> NSFetchRequest<Room> {
        let request = Room.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Room.roomType, ascending: true)
        ]
        return request
    }

    func flightsByAirlineFetch(for airline: Airline) -> NSFetchRequest<Flight> {
        let request: NSFetchRequest<Flight> = Flight.fetchRequest()
        
        request.predicate = NSPredicate(format: "airline == %@", airline)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Flight.departureTime, ascending: true)
        ]
        
        return request
    }
    
    func flightsByDestinationFetch(for destination: Destination) -> NSFetchRequest<Flight> {
        let request: NSFetchRequest<Flight> = Flight.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "arrivalAirport.destination == %@ OR departureAirport.destination == %@",
            destination,
            destination
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Flight.departureTime, ascending: true)
        ]
        
        return request
    }
    
    func hotelsByDestinationFetch(for destination: Destination) -> NSFetchRequest<Hotel> {
        let request: NSFetchRequest<Hotel> = Hotel.fetchRequest()
        
        request.predicate = NSPredicate(format: "destination == %@", destination)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Hotel.rating, ascending: false),
            NSSortDescriptor(keyPath: \Hotel.name, ascending: true)
        ]
        
        return request
    }
    
    func cabinsByFlightFetch(for flight: Flight) -> NSFetchRequest<Cabin> {
        let request: NSFetchRequest<Cabin> = Cabin.fetchRequest()
        
        request.predicate = NSPredicate(format: "flight == %@", flight)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Cabin.price, ascending: true)
        ]
        
        return request
    }
    
    func roomsByHotelFetch(for hotel: Hotel) -> NSFetchRequest<Room> {
        let request: NSFetchRequest<Room> = Room.fetchRequest()
        request.predicate = NSPredicate(format: "hotel == %@", hotel)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Room.roomType, ascending: true)
        ]
        return request
    }
    
    // MARK: - Predicates
    private func flightsPredicate() -> NSPredicate? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        var predicates: [NSPredicate] = []
        
        if !trimmed.isEmpty {
            let searchPredicate = NSPredicate(
                format: """
                (flightNumber CONTAINS[cd] %@) OR
                (airline.airlineName CONTAINS[cd] %@) OR
                (departureAirport.name CONTAINS[cd] %@) OR
                (arrivalAirport.name CONTAINS[cd] %@)
                """,
                trimmed, trimmed, trimmed, trimmed
            )
            predicates.append(searchPredicate)
        }
        
        if let selectedAirline {
            predicates.append(NSPredicate(format: "airline == %@", selectedAirline))
        }
        
        if let selectedDestination {
            predicates.append(
                NSPredicate(
                    format: "arrivalAirport.destination == %@ OR departureAirport.destination == %@",
                    selectedDestination,
                    selectedDestination
                )
            )
        }
        
        guard !predicates.isEmpty else { return nil }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    private func hotelsPredicate() -> NSPredicate? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        var predicates: [NSPredicate] = []
        
        if !trimmed.isEmpty {
            let searchPredicate = NSPredicate(
                format: """
                (name CONTAINS[cd] %@) OR
                (hotelAddress CONTAINS[cd] %@) OR
                (hotelDescription CONTAINS[cd] %@)
                """,
                trimmed, trimmed, trimmed
            )
            predicates.append(searchPredicate)
        }
        
        if let selectedDestination {
            predicates.append(NSPredicate(format: "destination == %@", selectedDestination))
        }
        
        guard !predicates.isEmpty else { return nil }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    // MARK: - Save
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshAll(context)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension BooklyHolder {
    
    func fetchUser(byId id: String, _ context: NSManagedObjectContext) -> AppUser? {
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch user by id: \(error)")
            return nil
        }
    }
    
    func fetchUser(byEmail email: String, _ context: NSManagedObjectContext) -> AppUser? {
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    @discardableResult
    func createUser(
        id: String,
        firstName: String,
        lastName: String,
        email: String,
        isActive: Bool,
        _ context: NSManagedObjectContext
    ) -> AppUser {
        let user = AppUser(context: context)
        user.id = id
        user.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        user.isActive = isActive
        
        saveContext(context)
        return user
    }
    
    func updateUser(
        user: AppUser,
        firstName: String,
        lastName: String,
        email: String,
        isActive: Bool,
        _ context: NSManagedObjectContext
    ) {
        user.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        user.isActive = isActive
        
        saveContext(context)
    }
    
    func updateUser(
        user: AppUser,
        firstName: String,
        lastName: String,
        _ context: NSManagedObjectContext
    ) {
        user.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        saveContext(context)
    }
}
