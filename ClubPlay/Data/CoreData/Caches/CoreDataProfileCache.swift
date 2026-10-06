//
//  CoreDataProfileCache.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

final class CoreDataProfileCache {
    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func save(_ member: ClubMember) throws {
        let request = NSFetchRequest<CachedProfile>(
            entityName: "CachedProfile"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            member.id as CVarArg
        )

        let cached =
            try context.fetch(request).first
            ?? CachedProfile(context: context)

        cached.update(from: member)

        if context.hasChanges {
            try context.save()
        }
    }

    func fetch(id: UUID) throws -> ClubMember? {
        let request = NSFetchRequest<CachedProfile>(
            entityName: "CachedProfile"
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