//
//  WeeklyFootballGameRow.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation

struct WeeklyFootballGameRow: Codable {
    let id: UUID
    let communityID: UUID
    let gameName: String
    let venueName: String
    let kickOffAt: Date
    let finishesAt: Date
    let playerCapacity: Int
    let registrationOpensAt: Date
    let registrationClosesAt: Date
    let cancellationDeadlineHours: Int
    let status: String
    let createdAt: Date
    let createdBy: UUID

    enum CodingKeys: String, CodingKey {
        case id
        case communityID = "community_id"
        case gameName = "game_name"
        case venueName = "venue_name"
        case kickOffAt = "kick_off_at"
        case finishesAt = "finishes_at"
        case playerCapacity = "player_capacity"
        case registrationOpensAt = "registration_opens_at"
        case registrationClosesAt = "registration_closes_at"
        case cancellationDeadlineHours = "cancellation_deadline_hours"
        case status
        case createdAt = "created_at"
        case createdBy = "created_by"
    }

    func toDomain() -> WeeklyFootballGame {
        WeeklyFootballGame(
            id: id,
            communityID: communityID,
            gameName: gameName,
            venueName: venueName,
            kickOffAt: kickOffAt,
            finishesAt: finishesAt,
            playerCapacity: playerCapacity,
            registrationOpensAt: registrationOpensAt,
            registrationClosesAt: registrationClosesAt,
            cancellationDeadlineHours: cancellationDeadlineHours,
            status: GameStatus(rawValue: status) ?? .draft,
            createdAt: createdAt,
            createdByMemberID: createdBy
        )
    }

    static func fromDomain(_ game: WeeklyFootballGame) -> Self {
        Self(
            id: game.id,
            communityID: game.communityID,
            gameName: game.gameName,
            venueName: game.venueName,
            kickOffAt: game.kickOffAt,
            finishesAt: game.finishesAt,
            playerCapacity: game.playerCapacity,
            registrationOpensAt: game.registrationOpensAt,
            registrationClosesAt: game.registrationClosesAt,
            cancellationDeadlineHours: game.cancellationDeadlineHours,
            status: game.status.rawValue,
            createdAt: game.createdAt,
            createdBy: game.createdByMemberID
        )
    }
}