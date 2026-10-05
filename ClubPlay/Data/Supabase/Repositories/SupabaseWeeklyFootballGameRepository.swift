//
//  SupabaseWeeklyFootballGameRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Supabase

final class SupabaseWeeklyFootballGameRepository:
    WeeklyFootballGameRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }

    func fetchUpcomingGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {

        let rows: [WeeklyFootballGameRow] = try await client
            .from("weekly_football_games")
            .select()
            .eq("community_id", value: communityID.uuidString)
            .eq("status", value: GameStatus.published.rawValue)
            .gt("kick_off_at", value: Date().ISO8601Format())
            .order("kick_off_at", ascending: true)
            .execute()
            .value

        return rows.map { $0.toDomain() }
    }

    func fetchGame(id: UUID) async throws -> WeeklyFootballGame? {
        let rows: [WeeklyFootballGameRow] = try await client
            .from("weekly_football_games")
            .select()
            .eq("id", value: id.uuidString)
            .limit(1)
            .execute()
            .value

        return rows.first?.toDomain()
    }
    
    func fetchGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {

        let rows: [WeeklyFootballGameRow] = try await client
            .from("weekly_football_games")
            .select()
            .eq("community_id", value: communityID.uuidString)
            .order("kick_off_at", ascending: true)
            .execute()
            .value

        return rows.map { $0.toDomain() }
    }

    func createGame(_ game: WeeklyFootballGame) async throws {
        let row = WeeklyFootballGameRow.fromDomain(game)

        try await client
            .from("weekly_football_games")
            .insert(row)
            .execute()
    }

    func updateGame(_ game: WeeklyFootballGame) async throws {
        let row = WeeklyFootballGameRow.fromDomain(game)

        try await client
            .from("weekly_football_games")
            .update(row)
            .eq("id", value: game.id.uuidString)
            .execute()
    }
}
