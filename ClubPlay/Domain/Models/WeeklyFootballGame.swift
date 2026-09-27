//
//  WeeklyFootballGame.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct WeeklyFootballGame: Identifiable, Codable, Equatable {
    let id: UUID

    let communityID: UUID

    var gameName: String
    var venueName: String

    var kickOffAt: Date
    var finishesAt: Date

    var playerCapacity: Int

    var registrationOpensAt: Date
    var registrationClosesAt: Date

    var cancellationDeadlineHours: Int

    var status: GameStatus

    let createdAt: Date
    let createdByMemberID: UUID
}
