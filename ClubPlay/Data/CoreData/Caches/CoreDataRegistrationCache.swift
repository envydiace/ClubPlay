//
//  CoreDataRegistrationCache.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

final class CoreDataRegistrationCache {
    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func save(
        _ registrations: [WeeklyGameRegistration]
    ) throws {
        for registration in registrations {
            try save(registration)
        }

        if context.hasChanges {
            try context.save()
        }
    }

    func save(
        _ registration: WeeklyGameRegistration
    ) throws {
        let request = NSFetchRequest<CachedRegistration>(
            entityName: "CachedRegistration"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id == %@",
            registration.id as CVarArg
        )

        let cached =
            try context.fetch(request).first
            ?? CachedRegistration(context: context)

        cached.update(from: registration)

        if context.hasChanges {
            try context.save()
        }
    }

    func fetchRegistration(
        memberID: UUID,
        gameID: UUID
    ) throws -> WeeklyGameRegistration? {
        let request = NSFetchRequest<CachedRegistration>(
            entityName: "CachedRegistration"
        )

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "memberID == %@ AND gameID == %@",
            memberID as CVarArg,
            gameID as CVarArg
        )

        return try context.fetch(request)
            .first?
            .toDomain()
    }

    func fetchRegistrations(
        forMemberID memberID: UUID
    ) throws -> [WeeklyGameRegistration] {
        let request = NSFetchRequest<CachedRegistration>(
            entityName: "CachedRegistration"
        )

        request.predicate = NSPredicate(
            format: "memberID == %@",
            memberID as CVarArg
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "registeredAt",
                ascending: false
            )
        ]

        return try context.fetch(request)
            .compactMap { $0.toDomain() }
    }

    func fetchRegistrations(
        forGameID gameID: UUID
    ) throws -> [WeeklyGameRegistration] {
        let request = NSFetchRequest<CachedRegistration>(
            entityName: "CachedRegistration"
        )

        request.predicate = NSPredicate(
            format: "gameID == %@",
            gameID as CVarArg
        )

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "registeredAt",
                ascending: true
            )
        ]

        return try context.fetch(request)
            .compactMap { $0.toDomain() }
    }
}
