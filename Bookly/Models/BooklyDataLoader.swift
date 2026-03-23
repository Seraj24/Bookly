//
//  BooklyDataLoader.swift
//  Bookly
//
//  Created by user938962 on 3/23/26.
//

import Foundation
import CoreData

final class BooklyDataLoader {
    private let context: NSManagedObjectContext
    private let holder: BooklyHolder

    init(context: NSManagedObjectContext, holder: BooklyHolder) {
        self.context = context
        self.holder = holder
    }

    func loadInitialData() async {
        holder.refreshAll(context)

        if hasLocalData() {
            print("Core Data already has local data. Skipping Firestore sync.")
            return
        }

        do {
            let remoteData = try await FirestoreFetchService.shared.fetchAllSeedData()

            if remoteData.isEmpty {
                print("Firestore returned no data.")
                return
            }

            try await CoreDataSyncService.shared.syncAll(remoteData, into: context)
            holder.refreshAll(context)

            print("Firestore data fetched and synced into Core Data successfully.")
        } catch {
            print("Failed to load initial data: \(error.localizedDescription)")
        }
    }

    func forceRefreshFromFirestore() async {
        do {
            let remoteData = try await FirestoreFetchService.shared.fetchAllSeedData()

            if remoteData.isEmpty {
                print("Firestore returned no data.")
                return
            }

            try await CoreDataSyncService.shared.syncAll(remoteData, into: context)
            holder.refreshAll(context)

            print("Firestore force refresh completed successfully.")
        } catch {
            print("Failed to force refresh Firestore data: \(error.localizedDescription)")
        }
    }

    private func hasLocalData() -> Bool {
        let request: NSFetchRequest<Destination> = Destination.fetchRequest()
        request.fetchLimit = 1

        do {
            return try context.count(for: request) > 0
        } catch {
            print("Failed to check local Core Data state: \(error.localizedDescription)")
            return false
        }
    }
}
