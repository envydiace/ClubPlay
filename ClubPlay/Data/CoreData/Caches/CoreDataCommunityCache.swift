//
//  CoreDataCommunityCache.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

final class CoreDataCommunityCache {
    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func save(_ community: Community) throws {
        let request = NSFetchRequest<CachedCommunity>(
            entityName: "CachedCommunity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            community.id as CVarArg
        )

        let cached =
            try context.fetch(request).first
            ?? CachedCommunity(context: context)

        cached.update(from: community)

        if context.hasChanges {
            try context.save()
        }
    }

    func fetch(id: UUID) throws -> Community? {
        let request = NSFetchRequest<CachedCommunity>(
            entityName: "CachedCommunity"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        return try context.fetch(request)
            .first?
            .toDomain()
    }
}