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

extension CachedGame {

    func toDomain() -> WeeklyFootballGame? {
        guard
            let id,
            let communityID,
            let gameName,
            let venueName,
            let kickOffAt,
            let finishesAt,
            let registrationOpensAt,
            let registrationClosesAt,
            let status,
            let gameStatus = GameStatus(rawValue: status),
            let createdAt,
            let createdByMemberID
        else {
            return nil
        }

        return WeeklyFootballGame(
            id: id,
            communityID: communityID,
            gameName: gameName,
            venueName: venueName,
            kickOffAt: kickOffAt,
            finishesAt: finishesAt,
            playerCapacity: Int(playerCapacity),
            registrationOpensAt: registrationOpensAt,
            registrationClosesAt: registrationClosesAt,
            cancellationDeadlineHours: Int(cancellationDeadlineHours),
            status: gameStatus,
            createdAt: createdAt,
            createdByMemberID: createdByMemberID
        )
    }

    func update(
        from game: WeeklyFootballGame,
        syncedAt: Date = Date()
    ) {
        id = game.id
        communityID = game.communityID
        gameName = game.gameName
        venueName = game.venueName
        kickOffAt = game.kickOffAt
        finishesAt = game.finishesAt
        playerCapacity = Int64(game.playerCapacity)
        registrationOpensAt = game.registrationOpensAt
        registrationClosesAt = game.registrationClosesAt
        cancellationDeadlineHours =
            Int64(game.cancellationDeadlineHours)
        status = game.status.rawValue
        createdAt = game.createdAt
        createdByMemberID = game.createdByMemberID
        lastSyncedAt = syncedAt
    }
}
