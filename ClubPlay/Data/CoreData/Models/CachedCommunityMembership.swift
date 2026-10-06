//
//  CachedCommunityMembership.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

@objc(CachedCommunityMembership)
final class CachedCommunityMembership: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var memberID: UUID?
    @NSManaged var communityID: UUID?
    @NSManaged var role: String?
    @NSManaged var joinedAt: Date?
    @NSManaged var lastSyncedAt: Date?
}

extension CachedCommunityMembership {
    func toDomain() -> CommunityMembership? {
        guard
            let id,
            let memberID,
            let communityID,
            let role,
            let memberRole = ClubMemberRole(rawValue: role),
            let joinedAt
        else {
            return nil
        }

        return CommunityMembership(
            id: id,
            memberID: memberID,
            communityID: communityID,
            role: memberRole,
            joinedAt: joinedAt
        )
    }

    func update(
        from membership: CommunityMembership,
        syncedAt: Date = Date()
    ) {
        id = membership.id
        memberID = membership.memberID
        communityID = membership.communityID
        role = membership.role.rawValue
        joinedAt = membership.joinedAt
        lastSyncedAt = syncedAt
    }
}