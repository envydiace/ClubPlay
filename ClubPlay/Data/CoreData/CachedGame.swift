//
//  CachedGame.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

@objc(CachedGame)
final class CachedGame: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var communityID: UUID?

    @NSManaged var gameName: String?
    @NSManaged var venueName: String?

    @NSManaged var kickOffAt: Date?
    @NSManaged var finishesAt: Date?

    @NSManaged var playerCapacity: Int64

    @NSManaged var registrationOpensAt: Date?
    @NSManaged var registrationClosesAt: Date?

    @NSManaged var cancellationDeadlineHours: Int64

    @NSManaged var status: String?

    @NSManaged var createdAt: Date?
    @NSManaged var createdByMemberID: UUID?

    @NSManaged var lastSyncedAt: Date?
}