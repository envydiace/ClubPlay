//
//  CachedProfile.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

@objc(CachedProfile)
final class CachedProfile: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var fullName: String?
    @NSManaged var emailAddress: String?
    @NSManaged var lastSyncedAt: Date?
}

extension CachedProfile {
    func toDomain() -> ClubMember? {
        guard
            let id,
            let fullName,
            let emailAddress
        else {
            return nil
        }

        return ClubMember(
            id: id,
            fullName: fullName,
            emailAddress: emailAddress
        )
    }

    func update(
        from member: ClubMember,
        syncedAt: Date = Date()
    ) {
        id = member.id
        fullName = member.fullName
        emailAddress = member.emailAddress
        lastSyncedAt = syncedAt
    }
}