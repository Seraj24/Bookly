//
//  BooklySeeder.swift
//  Bookly
//
//  Created by user938962 on 3/10/26.
//

import Foundation
import CoreData

enum BooklySeeder {
    static func seedIfNeeded(_ context: NSManagedObjectContext) {
        let req = Destination.fetchRequest()
        req.fetchLimit = 1
        
        let count = (try? context.count(for: req)) ?? 0
        guard count == 0 else { return }
        
        // MARK: - Destinations
        let montreal = Destination(context: context)
        montreal.id = UUID()
        montreal.city = "Montreal"
        montreal.country = "Canada"
        
        let barcelona = Destination(context: context)
        barcelona.id = UUID()
        barcelona.city = "Barcelona"
        barcelona.country = "Spain"
        
        let toronto = Destination(context: context)
        toronto.id = UUID()
        toronto.city = "Toronto"
        toronto.country = "Canada"
        
        let vancouver = Destination(context: context)
        vancouver.id = UUID()
        vancouver.city = "Vancouver"
        vancouver.country = "Canada"
        
        let paris = Destination(context: context)
        paris.id = UUID()
        paris.city = "Paris"
        paris.country = "France"
        
        let london = Destination(context: context)
        london.id = UUID()
        london.city = "London"
        london.country = "United Kingdom"
        
        let dubai = Destination(context: context)
        dubai.id = UUID()
        dubai.city = "Dubai"
        dubai.country = "United Arab Emirates"
        
        let newYork = Destination(context: context)
        newYork.id = UUID()
        newYork.city = "New York"
        newYork.country = "United States"
        
        // MARK: - Airlines
        let airCanada = Airline(context: context)
        airCanada.id = UUID()
        airCanada.airlineName = "Air Canada"
        
        let vueling = Airline(context: context)
        vueling.id = UUID()
        vueling.airlineName = "Vueling"
        
        let westJet = Airline(context: context)
        westJet.id = UUID()
        westJet.airlineName = "WestJet"
        
        let britishAirways = Airline(context: context)
        britishAirways.id = UUID()
        britishAirways.airlineName = "British Airways"
        
        let emirates = Airline(context: context)
        emirates.id = UUID()
        emirates.airlineName = "Emirates"
        
        let airFrance = Airline(context: context)
        airFrance.id = UUID()
        airFrance.airlineName = "Air France"
        
        // MARK: - Airports
        let yul = Airport(context: context)
        yul.id = UUID()
        yul.name = "Montréal–Trudeau International Airport"
        yul.code = "YUL"
        yul.destination = montreal
        
        let bcn = Airport(context: context)
        bcn.id = UUID()
        bcn.name = "Barcelona–El Prat Airport"
        bcn.code = "BCN"
        bcn.destination = barcelona
        
        let yyz = Airport(context: context)
        yyz.id = UUID()
        yyz.name = "Toronto Pearson International Airport"
        yyz.code = "YYZ"
        yyz.destination = toronto
        
        let yvr = Airport(context: context)
        yvr.id = UUID()
        yvr.name = "Vancouver International Airport"
        yvr.code = "YVR"
        yvr.destination = vancouver
        
        let cdg = Airport(context: context)
        cdg.id = UUID()
        cdg.name = "Paris Charles de Gaulle Airport"
        cdg.code = "CDG"
        cdg.destination = paris
        
        let lhr = Airport(context: context)
        lhr.id = UUID()
        lhr.name = "London Heathrow Airport"
        lhr.code = "LHR"
        lhr.destination = london
        
        let dxb = Airport(context: context)
        dxb.id = UUID()
        dxb.name = "Dubai International Airport"
        dxb.code = "DXB"
        dxb.destination = dubai
        
        let jfk = Airport(context: context)
        jfk.id = UUID()
        jfk.name = "John F. Kennedy International Airport"
        jfk.code = "JFK"
        jfk.destination = newYork
        
        // MARK: - Hotels
        let hotel1 = Hotel(context: context)
        hotel1.id = UUID()
        hotel1.name = "Hotel Arts Barcelona"
        hotel1.hotelAddress = "Marina 19–21, Barcelona"
        hotel1.hotelDescription = "Luxury seaside hotel with city views."
        hotel1.rating = 4.7
        hotel1.destination = barcelona

        createRoom(type: .single, price: 220, quantity: 5, hotel: hotel1, context: context)
        createRoom(type: .double, price: 320, quantity: 10, hotel: hotel1, context: context)
        createRoom(type: .suite, price: 550, quantity: 3, hotel: hotel1, context: context)

        let hotel2 = Hotel(context: context)
        hotel2.id = UUID()
        hotel2.name = "Le Mount Stephen"
        hotel2.hotelAddress = "1440 Drummond St, Montreal"
        hotel2.hotelDescription = "Elegant downtown stay close to shopping and dining."
        hotel2.rating = 4.6
        hotel2.destination = montreal

        createRoom(type: .single, price: 180, quantity: 6, hotel: hotel2, context: context)
        createRoom(type: .double, price: 260, quantity: 8, hotel: hotel2, context: context)
        createRoom(type: .suite, price: 420, quantity: 2, hotel: hotel2, context: context)

        let hotel3 = Hotel(context: context)
        hotel3.id = UUID()
        hotel3.name = "Fairmont Royal York"
        hotel3.hotelAddress = "100 Front St W, Toronto"
        hotel3.hotelDescription = "Historic luxury hotel in the heart of Toronto."
        hotel3.rating = 4.5
        hotel3.destination = toronto

        createRoom(type: .single, price: 200, quantity: 8, hotel: hotel3, context: context)
        createRoom(type: .double, price: 300, quantity: 12, hotel: hotel3, context: context)
        createRoom(type: .suite, price: 480, quantity: 4, hotel: hotel3, context: context)

        let hotel4 = Hotel(context: context)
        hotel4.id = UUID()
        hotel4.name = "Pan Pacific Vancouver"
        hotel4.hotelAddress = "999 Canada Pl, Vancouver"
        hotel4.hotelDescription = "Waterfront hotel with stunning harbor views."
        hotel4.rating = 4.4
        hotel4.destination = vancouver

        createRoom(type: .single, price: 190, quantity: 4, hotel: hotel4, context: context)
        createRoom(type: .double, price: 280, quantity: 9, hotel: hotel4, context: context)
        createRoom(type: .suite, price: 460, quantity: 2, hotel: hotel4, context: context)

        let hotel5 = Hotel(context: context)
        hotel5.id = UUID()
        hotel5.name = "Pullman Paris Tour Eiffel"
        hotel5.hotelAddress = "18 Avenue de Suffren, Paris"
        hotel5.hotelDescription = "Modern hotel near the Eiffel Tower."
        hotel5.rating = 4.3
        hotel5.destination = paris

        createRoom(type: .single, price: 210, quantity: 5, hotel: hotel5, context: context)
        createRoom(type: .double, price: 310, quantity: 11, hotel: hotel5, context: context)
        createRoom(type: .suite, price: 500, quantity: 3, hotel: hotel5, context: context)

        let hotel6 = Hotel(context: context)
        hotel6.id = UUID()
        hotel6.name = "The Tower Hotel"
        hotel6.hotelAddress = "St Katharine's Way, London"
        hotel6.hotelDescription = "Comfortable stay near Tower Bridge."
        hotel6.rating = 4.2
        hotel6.destination = london

        createRoom(type: .single, price: 170, quantity: 7, hotel: hotel6, context: context)
        createRoom(type: .double, price: 250, quantity: 10, hotel: hotel6, context: context)
        createRoom(type: .suite, price: 400, quantity: 2, hotel: hotel6, context: context)

        let hotel7 = Hotel(context: context)
        hotel7.id = UUID()
        hotel7.name = "Atlantis The Palm"
        hotel7.hotelAddress = "Crescent Rd, Dubai"
        hotel7.hotelDescription = "Iconic luxury resort with world-class amenities."
        hotel7.rating = 4.8
        hotel7.destination = dubai

        createRoom(type: .single, price: 300, quantity: 6, hotel: hotel7, context: context)
        createRoom(type: .double, price: 450, quantity: 14, hotel: hotel7, context: context)
        createRoom(type: .suite, price: 900, quantity: 6, hotel: hotel7, context: context)

        let hotel8 = Hotel(context: context)
        hotel8.id = UUID()
        hotel8.name = "The New Yorker Hotel"
        hotel8.hotelAddress = "481 8th Ave, New York"
        hotel8.hotelDescription = "Classic Manhattan stay with easy city access."
        hotel8.rating = 4.1
        hotel8.destination = newYork

        createRoom(type: .single, price: 160, quantity: 8, hotel: hotel8, context: context)
        createRoom(type: .double, price: 240, quantity: 12, hotel: hotel8, context: context)
        createRoom(type: .suite, price: 380, quantity: 3, hotel: hotel8, context: context)
        
        // MARK: - Flights
        let now = Date()
        
        let flight1 = Flight(context: context)
        flight1.id = UUID()
        flight1.flightNumber = "VY101"
        flight1.departureTime = now
        flight1.arrivalTime = Calendar.current.date(byAdding: .hour, value: 7, to: now) ?? now
        flight1.duration = 7 * 3600
        flight1.airline = vueling
        flight1.departureAirport = yul
        flight1.arrivalAirport = bcn
        
        let flight2 = Flight(context: context)
        flight2.id = UUID()
        flight2.flightNumber = "AC420"
        flight2.departureTime = Calendar.current.date(byAdding: .hour, value: 3, to: now) ?? now
        flight2.arrivalTime = Calendar.current.date(byAdding: .hour, value: 4, to: flight2.departureTime ?? now) ?? now
        flight2.duration = 4 * 3600
        flight2.airline = airCanada
        flight2.departureAirport = yul
        flight2.arrivalAirport = yyz
        
        let flight3 = Flight(context: context)
        flight3.id = UUID()
        flight3.flightNumber = "WS315"
        flight3.departureTime = Calendar.current.date(byAdding: .hour, value: 6, to: now) ?? now
        flight3.arrivalTime = Calendar.current.date(byAdding: .hour, value: 5, to: flight3.departureTime ?? now) ?? now
        flight3.duration = 5 * 3600
        flight3.airline = westJet
        flight3.departureAirport = yyz
        flight3.arrivalAirport = yvr
        
        let flight4 = Flight(context: context)
        flight4.id = UUID()
        flight4.flightNumber = "AF351"
        flight4.departureTime = Calendar.current.date(byAdding: .hour, value: 9, to: now) ?? now
        flight4.arrivalTime = Calendar.current.date(byAdding: .hour, value: 7, to: flight4.departureTime ?? now) ?? now
        flight4.duration = 7 * 3600
        flight4.airline = airFrance
        flight4.departureAirport = yul
        flight4.arrivalAirport = cdg
        
        let flight5 = Flight(context: context)
        flight5.id = UUID()
        flight5.flightNumber = "BA212"
        flight5.departureTime = Calendar.current.date(byAdding: .hour, value: 12, to: now) ?? now
        flight5.arrivalTime = Calendar.current.date(byAdding: .hour, value: 7, to: flight5.departureTime ?? now) ?? now
        flight5.duration = 7 * 3600
        flight5.airline = britishAirways
        flight5.departureAirport = yul
        flight5.arrivalAirport = lhr
        
        let flight6 = Flight(context: context)
        flight6.id = UUID()
        flight6.flightNumber = "EK244"
        flight6.departureTime = Calendar.current.date(byAdding: .hour, value: 15, to: now) ?? now
        flight6.arrivalTime = Calendar.current.date(byAdding: .hour, value: 12, to: flight6.departureTime ?? now) ?? now
        flight6.duration = 12 * 3600
        flight6.airline = emirates
        flight6.departureAirport = yul
        flight6.arrivalAirport = dxb
        
        let flight7 = Flight(context: context)
        flight7.id = UUID()
        flight7.flightNumber = "AC701"
        flight7.departureTime = Calendar.current.date(byAdding: .hour, value: 18, to: now) ?? now
        flight7.arrivalTime = Calendar.current.date(byAdding: .hour, value: 2, to: flight7.departureTime ?? now) ?? now
        flight7.duration = 2 * 3600
        flight7.airline = airCanada
        flight7.departureAirport = yul
        flight7.arrivalAirport = jfk
        
        let flight8 = Flight(context: context)
        flight8.id = UUID()
        flight8.flightNumber = "VY202"
        flight8.departureTime = Calendar.current.date(byAdding: .hour, value: 21, to: now) ?? now
        flight8.arrivalTime = Calendar.current.date(byAdding: .hour, value: 7, to: flight8.departureTime ?? now) ?? now
        flight8.duration = 7 * 3600
        flight8.airline = vueling
        flight8.departureAirport = bcn
        flight8.arrivalAirport = yul
        
        // MARK: - Cabins
        let economy1 = Cabin(context: context)
        economy1.id = UUID()
        economy1.cabinClass = "Economy"
        economy1.price = 699.99
        economy1.remainingSeats = 42
        economy1.flight = flight1
        
        let business1 = Cabin(context: context)
        business1.id = UUID()
        business1.cabinClass = "Business"
        business1.price = 1499.99
        business1.remainingSeats = 10
        business1.flight = flight1
        
        let economy2 = Cabin(context: context)
        economy2.id = UUID()
        economy2.cabinClass = "Economy"
        economy2.price = 249.99
        economy2.remainingSeats = 58
        economy2.flight = flight2
        
        let premium2 = Cabin(context: context)
        premium2.id = UUID()
        premium2.cabinClass = "Premium Economy"
        premium2.price = 499.99
        premium2.remainingSeats = 18
        premium2.flight = flight2
        
        let economy3 = Cabin(context: context)
        economy3.id = UUID()
        economy3.cabinClass = "Economy"
        economy3.price = 299.99
        economy3.remainingSeats = 61
        economy3.flight = flight3
        
        let economy4 = Cabin(context: context)
        economy4.id = UUID()
        economy4.cabinClass = "Economy"
        economy4.price = 820.00
        economy4.remainingSeats = 37
        economy4.flight = flight4
        
        let business4 = Cabin(context: context)
        business4.id = UUID()
        business4.cabinClass = "Business"
        business4.price = 1720.00
        business4.remainingSeats = 9
        business4.flight = flight4
        
        let economy5 = Cabin(context: context)
        economy5.id = UUID()
        economy5.cabinClass = "Economy"
        economy5.price = 780.00
        economy5.remainingSeats = 44
        economy5.flight = flight5
        
        let business5 = Cabin(context: context)
        business5.id = UUID()
        business5.cabinClass = "Business"
        business5.price = 1650.00
        business5.remainingSeats = 11
        business5.flight = flight5
        
        let economy6 = Cabin(context: context)
        economy6.id = UUID()
        economy6.cabinClass = "Economy"
        economy6.price = 1099.99
        economy6.remainingSeats = 50
        economy6.flight = flight6
        
        let business6 = Cabin(context: context)
        business6.id = UUID()
        business6.cabinClass = "Business"
        business6.price = 2499.99
        business6.remainingSeats = 8
        business6.flight = flight6
        
        let economy7 = Cabin(context: context)
        economy7.id = UUID()
        economy7.cabinClass = "Economy"
        economy7.price = 199.99
        economy7.remainingSeats = 63
        economy7.flight = flight7
        
        let economy8 = Cabin(context: context)
        economy8.id = UUID()
        economy8.cabinClass = "Economy"
        economy8.price = 719.99
        economy8.remainingSeats = 40
        economy8.flight = flight8
        
        let business8 = Cabin(context: context)
        business8.id = UUID()
        business8.cabinClass = "Business"
        business8.price = 1520.00
        business8.remainingSeats = 12
        business8.flight = flight8
        
        do {
            try context.save()
        } catch {
            print("Seed failed: \(error)")
            
        }
        
        func createRoom(
            type: RoomType,
            price: Double,
            quantity: Int32,
            hotel: Hotel,
            context: NSManagedObjectContext
        ) {
            let room = Room(context: context)
            room.roomType = type.rawValue
            room.price = price
            room.quantity = quantity
            room.hotel = hotel
        }
    }
}
