//
//  CoreDataCommunityMembershipCache.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

final class CoreDataCommunityMembershipCache {
    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func save(_ membership: CommunityMembership) throws {
        let request = NSFetchRequest<CachedCommunityMembership>(
            entityName: "CachedCommunityMembership"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            membership.id as CVarArg
        )

        let cached =
            try context.fetch(request).first
            ?? CachedCommunityMembership(context: context)

        cached.update(from: membership)

        if context.hasChanges {
            try context.save()
        }
    }

    func save(_ memberships: [CommunityMembership]) throws {
        for membership in memberships {
            try save(membership)
        }
    }

    func fetch(
        memberID: UUID,
        communityID: UUID
    ) throws -> CommunityMembership? {
        let request = NSFetchRequest<CachedCommunityMembership>(
            entityName: "CachedCommunityMembership"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "memberID == %@ AND communityID == %@",
            memberID as CVarArg,
            communityID as CVarArg
        )

        return try context.fetch(request)
            .first?
            .toDomain()
    }

    func fetch(
        forMemberID memberID: UUID
    ) throws -> [CommunityMembership] {
        let request = NSFetchRequest<CachedCommunityMembership>(
            entityName: "CachedCommunityMembership"
        )

        request.predicate = NSPredicate(
            format: "memberID == %@",
            memberID as CVarArg
        )

        return try context.fetch(request)
            .compactMap { $0.toDomain() }
    }
    
    func fetch(
        forCommunityID communityID: UUID
    ) throws -> [CommunityMembership] {
        let request = NSFetchRequest<CachedCommunityMembership>(
            entityName: "CachedCommunityMembership"
        )

        request.predicate = NSPredicate(
            format: "communityID == %@",
            communityID as CVarArg
        )

        return try context.fetch(request)
            .compactMap { $0.toDomain() }
    }
}
