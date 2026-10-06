//
//  CachedCommunity.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

@objc(CachedCommunity)
final class CachedCommunity: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var name: String?
    @NSManaged var createdAt: Date?
    @NSManaged var createdByMemberID: UUID?
    @NSManaged var lastSyncedAt: Date?
}

extension CachedCommunity {
    func toDomain() -> Community? {
        guard
            let id,
            let name,
            let createdAt,
            let createdByMemberID
        else {
            return nil
        }

        return Community(
            id: id,
            name: name,
            createdAt: createdAt,
            createdByMemberID: createdByMemberID
        )
    }

    func update(
        from community: Community,
        syncedAt: Date = Date()
    ) {
        id = community.id
        name = community.name
        createdAt = community.createdAt
        createdByMemberID = community.createdByMemberID
        lastSyncedAt = syncedAt
    }
}