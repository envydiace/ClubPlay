//
//  CachedGameMapper.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

enum CachedGameMapper {

    static func toDomain(_ cached: CachedGame) -> WeeklyFootballGame? {
        guard
            let id = cached.id,
            let communityID = cached.communityID,
            let gameName = cached.gameName,
            let venueName = cached.venueName,
            let kickOffAt = cached.kickOffAt,
            let finishesAt = cached.finishesAt,
            let registrationOpensAt = cached.registrationOpensAt,
            let registrationClosesAt = cached.registrationClosesAt,
            let statusRaw = cached.status,
            let status = GameStatus(rawValue: statusRaw),
            let createdAt = cached.createdAt,
            let createdByMemberID = cached.createdByMemberID
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
            playerCapacity: Int(cached.playerCapacity),
            registrationOpensAt: registrationOpensAt,
            registrationClosesAt: registrationClosesAt,
            cancellationDeadlineHours: Int(cached.cancellationDeadlineHours),
            status: status,
            createdAt: createdAt,
            createdByMemberID: createdByMemberID
        )
    }

    static func update(
        _ cached: CachedGame,
        from game: WeeklyFootballGame,
        syncedAt: Date = Date()
    ) {
        cached.id = game.id
        cached.communityID = game.communityID
        cached.gameName = game.gameName
        cached.venueName = game.venueName
        cached.kickOffAt = game.kickOffAt
        cached.finishesAt = game.finishesAt
        cached.playerCapacity = Int64(game.playerCapacity)
        cached.registrationOpensAt = game.registrationOpensAt
        cached.registrationClosesAt = game.registrationClosesAt
        cached.cancellationDeadlineHours =
            Int64(game.cancellationDeadlineHours)
        cached.status = game.status.rawValue
        cached.createdAt = game.createdAt
        cached.createdByMemberID = game.createdByMemberID
        cached.lastSyncedAt = syncedAt
    }
}