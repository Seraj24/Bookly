//
//  FirestoreFetchService.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation
import FirebaseFirestore

final class FirestoreFetchService {
    static let shared = FirestoreFetchService()

    private let db = Firestore.firestore()

    private init() {}

    func fetchAllSeedData() async throws -> BooklyRemoteData {
        async let destinations: [DestinationDocument] = fetchCollection("destinations")
        async let airlines: [AirlineDocument] = fetchCollection("airlines")
        async let airports: [AirportDocument] = fetchCollection("airports")
        async let hotels: [HotelDocument] = fetchCollection("hotels")
        async let rooms: [RoomDocument] = fetchCollection("rooms")
        async let flights: [FlightDocument] = fetchCollection("flights")
        async let cabins: [CabinDocument] = fetchCollection("cabins")

        return try await BooklyRemoteData(
            destinations: destinations,
            airlines: airlines,
            airports: airports,
            hotels: hotels,
            rooms: rooms,
            flights: flights,
            cabins: cabins
        )
    }

    private func fetchCollection<T: Decodable>(_ name: String) async throws -> [T] {
        let snapshot = try await db.collection(name).getDocuments()

        var results: [T] = []

        for document in snapshot.documents {
            do {
                let item = try document.data(as: T.self)
                results.append(item)
            } catch {
                print("-- Firestore Decoding Failed --")
                print("Collection: \(name)")
                print("Document ID: \(document.documentID)")
                print("Raw Data: \(document.data())")
                print("Error: \(error)")
                throw error
            }
        }

        return results
    }
}
