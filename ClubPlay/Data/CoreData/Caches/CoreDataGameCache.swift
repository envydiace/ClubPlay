//
//  CoreDataGameCache.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

final class CoreDataGameCache {
    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func save(
        _ games: [WeeklyFootballGame],
        communityID: UUID
    ) throws {
        for game in games {
            let request = NSFetchRequest<CachedGame>(
                entityName: "CachedGame"
            )
            request.fetchLimit = 1
            request.predicate = NSPredicate(
                format: "id == %@",
                game.id as CVarArg
            )

            let cached =
                try context.fetch(request).first
                ?? CachedGame(context: context)

            cached.update(from: game)
        }

        if context.hasChanges {
            try context.save()
        }
    }

    func fetchUpcomingGames(
        communityID: UUID,
        currentDate: Date = Date()
    ) throws -> [WeeklyFootballGame] {
        let request = NSFetchRequest<CachedGame>(
            entityName: "CachedGame"
        )

        request.predicate = NSPredicate(
            format: """
            communityID == %@ AND
            status == %@ AND
            kickOffAt > %@
            """,
            communityID as CVarArg,
            GameStatus.published.rawValue,
            currentDate as NSDate
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "kickOffAt",
                ascending: true
            )
        ]

        return try context.fetch(request)
            .compactMap { $0.toDomain() }
    }
}
