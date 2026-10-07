//
//  MockWeeklyFootballGameRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//

import Foundation
@testable import ClubPlay

final class MockWeeklyFootballGameRepository:
    WeeklyFootballGameRepository {

    var games: [WeeklyFootballGame] = []

    func fetchUpcomingGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {
        games.filter {
            $0.communityID == communityID &&
            $0.status == .published
        }
    }

    func fetchGame(
        id: UUID
    ) async throws -> WeeklyFootballGame? {
        games.first { $0.id == id }
    }

    func fetchGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {
        games.filter {
            $0.communityID == communityID
        }
    }

    func createGame(
        _ game: WeeklyFootballGame
    ) async throws {
        games.append(game)
    }

    func updateGame(
        _ game: WeeklyFootballGame
    ) async throws {
        guard let index = games.firstIndex(
            where: { $0.id == game.id }
        ) else {
            return
        }

        games[index] = game
    }
}
