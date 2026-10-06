//
//  CachedWeeklyFootballGameRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

final class CachedWeeklyFootballGameRepository:
    WeeklyFootballGameRepository {

    private let remoteRepository: WeeklyFootballGameRepository
    private let gameCache: CoreDataGameCache

    init(
        remoteRepository: WeeklyFootballGameRepository,
        gameCache: CoreDataGameCache
    ) {
        self.remoteRepository = remoteRepository
        self.gameCache = gameCache
    }

    func fetchUpcomingGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {

        do {
            let games = try await remoteRepository.fetchUpcomingGames(
                communityID: communityID
            )

            try gameCache.save(
                games,
                communityID: communityID
            )

            return games

        } catch {
            let cachedGames = try gameCache.fetchUpcomingGames(
                communityID: communityID
            )

            if !cachedGames.isEmpty {
                return cachedGames
            }

            throw error
        }
    }

    func fetchGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {
        try await remoteRepository.fetchGames(
            communityID: communityID
        )
    }

    func fetchGame(
        id: UUID
    ) async throws -> WeeklyFootballGame? {
        try await remoteRepository.fetchGame(id: id)
    }

    func createGame(
        _ game: WeeklyFootballGame
    ) async throws {
        try await remoteRepository.createGame(game)
    }

    func updateGame(
        _ game: WeeklyFootballGame
    ) async throws {
        try await remoteRepository.updateGame(game)
    }
}