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
        BooklySeeder.seedIfNeeded(context)
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
    
    // MARK: - Airline CRUD
    func createAirline(
        airlineName: String,
        _ context: NSManagedObjectContext
    ) {
        let nameTrimmed = airlineName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nameTrimmed.isEmpty else { return }
        
        let airline = Airline(context: context)
        airline.id = UUID()
        airline.airlineName = nameTrimmed
        
        saveContext(context)
    }
    
    func updateAirline(
        airline: Airline,
        airlineName: String,
        _ context: NSManagedObjectContext
    ) {
        airline.airlineName = airlineName.trimmingCharacters(in: .whitespacesAndNewlines)
        saveContext(context)
    }
    
    func deleteAirline(_ airline: Airline, _ context: NSManagedObjectContext) {
        if selectedAirline == airline {
            selectedAirline = nil
        }
        context.delete(airline)
        saveContext(context)
    }
    
    // MARK: - Airport CRUD
    func createAirport(
        name: String,
        code: String,
        destination: Destination?,
        _ context: NSManagedObjectContext
    ) {
        let nameTrimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let codeTrimmed = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !nameTrimmed.isEmpty && !codeTrimmed.isEmpty else { return }
        
        let airport = Airport(context: context)
        airport.id = UUID()
        airport.name = nameTrimmed
        airport.code = codeTrimmed
        airport.destination = destination
        
        saveContext(context)
    }
    
    func updateAirport(
        airport: Airport,
        name: String,
        code: String,
        destination: Destination?,
        _ context: NSManagedObjectContext
    ) {
        airport.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        airport.code = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        airport.destination = destination
        
        saveContext(context)
    }
    
    func deleteAirport(_ airport: Airport, _ context: NSManagedObjectContext) {
        context.delete(airport)
        saveContext(context)
    }
    
    // MARK: - AppUser CRUD
    
    func deleteUser(_ user: AppUser, _ context: NSManagedObjectContext) {
        context.delete(user)
        saveContext(context)
    }
    
    // MARK: - Destination CRUD
    func createDestination(
        city: String,
        country: String,
        _ context: NSManagedObjectContext
    ) {
        let cityTrimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let countryTrimmed = country.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cityTrimmed.isEmpty && !countryTrimmed.isEmpty else { return }
        
        let destination = Destination(context: context)
        destination.id = UUID()
        destination.city = cityTrimmed
        destination.country = countryTrimmed
        
        saveContext(context)
    }
    
    func updateDestination(
        destination: Destination,
        city: String,
        country: String,
        _ context: NSManagedObjectContext
    ) {
        destination.city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        destination.country = country.trimmingCharacters(in: .whitespacesAndNewlines)
        
        saveContext(context)
    }
    
    func deleteDestination(_ destination: Destination, _ context: NSManagedObjectContext) {
        if selectedDestination == destination {
            selectedDestination = nil
        }
        context.delete(destination)
        saveContext(context)
    }
    
    // MARK: - Hotel CRUD
    func createHotel(
        name: String,
        hotelAddress: String,
        hotelDescription: String,
        rating: Float,
        destination: Destination?,
        _ context: NSManagedObjectContext
    ) {
        let nameTrimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let addressTrimmed = hotelAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptionTrimmed = hotelDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !nameTrimmed.isEmpty, !addressTrimmed.isEmpty else { return }
        
        let hotel = Hotel(context: context)
        hotel.id = UUID()
        hotel.name = nameTrimmed
        hotel.hotelAddress = addressTrimmed
        hotel.hotelDescription = descriptionTrimmed
        hotel.rating = rating
        hotel.destination = destination
        
        saveContext(context)
    }
    
    func updateHotel(
        hotel: Hotel,
        name: String,
        hotelAddress: String,
        hotelDescription: String,
        rating: Float,
        destination: Destination?,
        _ context: NSManagedObjectContext
    ) {
        hotel.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        hotel.hotelAddress = hotelAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        hotel.hotelDescription = hotelDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        hotel.rating = rating
        hotel.destination = destination
        
        saveContext(context)
    }
    
    func deleteHotel(_ hotel: Hotel, _ context: NSManagedObjectContext) {
        context.delete(hotel)
        saveContext(context)
    }
    
    // MARK: - Flight CRUD
    func createFlight(
        flightNumber: String,
        departureTime: Date,
        arrivalTime: Date,
        duration: Double,
        airline: Airline?,
        departureAirport: Airport?,
        arrivalAirport: Airport?,
        _ context: NSManagedObjectContext
    ) {
        let numberTrimmed = flightNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !numberTrimmed.isEmpty else { return }
        
        let flight = Flight(context: context)
        flight.id = UUID()
        flight.flightNumber = numberTrimmed
        flight.departureTime = departureTime
        flight.arrivalTime = arrivalTime
        flight.duration = duration
        flight.airline = airline
        flight.departureAirport = departureAirport
        flight.arrivalAirport = arrivalAirport
        
        saveContext(context)
    }
    
    func updateFlight(
        flight: Flight,
        flightNumber: String,
        departureTime: Date,
        arrivalTime: Date,
        duration: Double,
        airline: Airline?,
        departureAirport: Airport?,
        arrivalAirport: Airport?,
        _ context: NSManagedObjectContext
    ) {
        flight.flightNumber = flightNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        flight.departureTime = departureTime
        flight.arrivalTime = arrivalTime
        flight.duration = duration
        flight.airline = airline
        flight.departureAirport = departureAirport
        flight.arrivalAirport = arrivalAirport
        
        saveContext(context)
    }
    
    func deleteFlight(_ flight: Flight, _ context: NSManagedObjectContext) {
        context.delete(flight)
        saveContext(context)
    }
    
    // MARK: - Cabin CRUD
    func createCabin(
        cabinClass: String,
        price: Double,
        remainingSeats: Int16,
        flight: Flight?,
        _ context: NSManagedObjectContext
    ) {
        let cabinClassTrimmed = cabinClass.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cabinClassTrimmed.isEmpty else { return }
        
        let cabin = Cabin(context: context)
        cabin.id = UUID()
        cabin.cabinClass = cabinClassTrimmed
        cabin.price = price
        cabin.remainingSeats = remainingSeats
        cabin.flight = flight
        
        saveContext(context)
    }
    
    func updateCabin(
        cabin: Cabin,
        cabinClass: String,
        price: Double,
        remainingSeats: Int16,
        flight: Flight?,
        _ context: NSManagedObjectContext
    ) {
        cabin.cabinClass = cabinClass.trimmingCharacters(in: .whitespacesAndNewlines)
        cabin.price = price
        cabin.remainingSeats = remainingSeats
        cabin.flight = flight
        
        saveContext(context)
    }
    
    func deleteCabin(_ cabin: Cabin, _ context: NSManagedObjectContext) {
        context.delete(cabin)
        saveContext(context)
    }
    
    func updateRoom(
        room: Room,
        roomType: String,
        quantity: Int32,
        hotel: Hotel?,
        _ context: NSManagedObjectContext
    ) {
        room.roomType = roomType.trimmingCharacters(in: .whitespacesAndNewlines)
        room.quantity = quantity
        room.hotel = hotel

        saveContext(context)
    }

    func deleteRoom(_ room: Room, _ context: NSManagedObjectContext) {
        context.delete(room)
        saveContext(context)
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
