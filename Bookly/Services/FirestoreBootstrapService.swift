//
//  DataService.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation
import FirebaseFirestore


final class FirestoreBootstrapService {
    static let shared = FirestoreBootstrapService()

    private let db = Firestore.firestore()

    private init() {}

    // MARK: Public API

    func uploadSeedDataIfNeeded(
        fileName: String = "bookly_seed_data_full",
        fileExtension: String = "json"
    ) async throws {
        if try await hasSeedDataAlready() {
            print("Firestore already contains seed data. Skipping upload.")
            return
        }

        let seedData = try loadSeedDataFromBundle(
            fileName: fileName,
            fileExtension: fileExtension
        )

        try await uploadAll(seedData)
        print("Seed data uploaded successfully.")
    }

    func forceUploadSeedData(
        fileName: String = "bookly_seed_data_full",
        fileExtension: String = "json"
    ) async throws {
        let seedData = try loadSeedDataFromBundle(
            fileName: fileName,
            fileExtension: fileExtension
        )

        try await uploadAll(seedData)
        print("Seed data force-uploaded successfully.")
    }

    // MARK: Empty Check

    private func hasSeedDataAlready() async throws -> Bool {
        let snapshot = try await db.collection("destinations")
            .limit(to: 1)
            .getDocuments()

        return !snapshot.documents.isEmpty
    }

    // MARK: JSON Loading

    private func loadSeedDataFromBundle(
        fileName: String,
        fileExtension: String
    ) throws -> BooklySeedData {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw BootstrapError.fileNotFound("\(fileName).\(fileExtension) not found in app bundle.")
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(BooklySeedData.self, from: data)
    }

    // MARK: Upload Pipeline

    private func uploadAll(_ seedData: BooklySeedData) async throws {
        try await uploadDestinations(seedData.destinations)
        try await uploadAirlines(seedData.airlines)
        try await uploadAirports(seedData.airports)
        try await uploadHotels(seedData.hotels)
        try await uploadRooms(seedData.rooms)
        try await uploadFlights(seedData.flights)
        try await uploadCabins(seedData.cabins)
    }

    // MARK: Collection Uploaders

    private func uploadDestinations(_ items: [DestinationSeed]) async throws {
        let batch = db.batch()

        for item in items {
            let doc = DestinationDocument(
                id: item.id.uuidString,
                city: item.city,
                country: item.country,
                latitude: item.latitude,
                longitude: item.longitude
            )

            let ref = db.collection("destinations").document(doc.id)
            try batch.setData(from: doc, forDocument: ref)
        }

        try await batch.commit()
    }

    private func uploadAirlines(_ items: [AirlineSeed]) async throws {
        let batch = db.batch()

        for item in items {
            let doc = AirlineDocument(
                id: item.id.uuidString,
                airlineName: item.airlineName
            )

            let ref = db.collection("airlines").document(doc.id)
            try batch.setData(from: doc, forDocument: ref)
        }

        try await batch.commit()
    }

    private func uploadAirports(_ items: [AirportSeed]) async throws {
        let batch = db.batch()

        for item in items {
            let doc = AirportDocument(
                id: item.id.uuidString,
                name: item.name,
                code: item.code,
                destinationId: item.destinationId.uuidString,
                latitude: item.latitude,
                longitude: item.longitude
            )

            let ref = db.collection("airports").document(doc.id)
            try batch.setData(from: doc, forDocument: ref)
        }

        try await batch.commit()
    }

    private func uploadHotels(_ items: [HotelSeed]) async throws {
        let batch = db.batch()

        for item in items {
            let doc = HotelDocument(
                id: item.id.uuidString,
                name: item.name,
                hotelAddress: item.hotelAddress,
                hotelDescription: item.hotelDescription,
                rating: item.rating,
                destinationId: item.destinationId.uuidString,
                latitude: item.latitude,
                longitude: item.longitude,
                photoURL: item.photoURL
            )

            let ref = db.collection("hotels").document(doc.id)
            try batch.setData(from: doc, forDocument: ref)
        }

        try await batch.commit()
    }

    private func uploadRooms(_ items: [RoomSeed]) async throws {
        let batch = db.batch()

        for item in items {
            let doc = RoomDocument(
                id: item.id.uuidString,
                roomType: item.roomType,
                price: item.price,
                quantity: item.quantity,
                hotelId: item.hotelId.uuidString
            )

            let ref = db.collection("rooms").document(doc.id)
            try batch.setData(from: doc, forDocument: ref)
        }

        try await batch.commit()
    }

    private func uploadFlights(_ items: [FlightSeed]) async throws {
        let batch = db.batch()

        for item in items {
            let doc = FlightDocument(
                id: item.id.uuidString,
                flightNumber: item.flightNumber,
                departureTime: item.departureTime,
                arrivalTime: item.arrivalTime,
                duration: item.duration,
                fromAirportId: item.departureAirportId.uuidString,
                toAirportId: item.arrivalAirportId.uuidString,
                airlineId: item.airlineId.uuidString
            )

            let ref = db.collection("flights").document(doc.id)
            try batch.setData(from: doc, forDocument: ref)
        }

        try await batch.commit()
    }

    private func uploadCabins(_ items: [CabinSeed]) async throws {
        let batch = db.batch()

        for item in items {
            let doc = CabinDocument(
                id: item.id.uuidString,
                cabinClass: item.cabinClass,
                price: item.price,
                remainingSeats: item.remainingSeats,
                flightId: item.flightId.uuidString
            )

            let ref = db.collection("cabins").document(doc.id)
            try batch.setData(from: doc, forDocument: ref)
        }

        try await batch.commit()
    }
}

// MARK: - Error Type

enum BootstrapError: LocalizedError {
    case fileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let message):
            return message
        }
    }
}
