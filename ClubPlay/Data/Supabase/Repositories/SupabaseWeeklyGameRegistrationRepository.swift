//
//  SupabaseWeeklyGameRegistrationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation
import Supabase

final class SupabaseWeeklyGameRegistrationRepository:
    WeeklyGameRegistrationRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }

    func fetchRegistration(
        id: UUID
    ) async throws -> WeeklyGameRegistration? {

        let rows: [WeeklyGameRegistrationRow] = try await client
            .from("weekly_game_registrations")
            .select()
            .eq("id", value: id.uuidString)
            .limit(1)
            .execute()
            .value

        return rows.first?.toDomain()
    }

    func fetchRegistration(
        memberID: UUID,
        gameID: UUID
    ) async throws -> WeeklyGameRegistration? {

        let rows: [WeeklyGameRegistrationRow] = try await client
            .from("weekly_game_registrations")
            .select()
            .eq("member_id", value: memberID.uuidString)
            .eq("game_id", value: gameID.uuidString)
            .limit(1)
            .execute()
            .value

        return rows.first?.toDomain()
    }

    func fetchRegistrations(
        forGameID gameID: UUID
    ) async throws -> [WeeklyGameRegistration] {

        let rows: [WeeklyGameRegistrationRow] = try await client
            .from("weekly_game_registrations")
            .select()
            .eq("game_id", value: gameID.uuidString)
            .order("registered_at", ascending: true)
            .execute()
            .value

        return rows.map { $0.toDomain() }
    }

    func fetchRegistrations(
        forMemberID memberID: UUID
    ) async throws -> [WeeklyGameRegistration] {

        let rows: [WeeklyGameRegistrationRow] = try await client
            .from("weekly_game_registrations")
            .select()
            .eq("member_id", value: memberID.uuidString)
            .order("registered_at", ascending: false)
            .execute()
            .value

        return rows.map { $0.toDomain() }
    }
    
    func promoteNextWaitlistedPlayer(
        gameID: UUID
    ) async throws -> UUID? {

        struct Params: Encodable {
            let p_game_id: UUID
        }

        let result: UUID? = try await client
            .rpc(
                "promote_next_waitlisted_player",
                params: Params(p_game_id: gameID)
            )
            .execute()
            .value

        return result
    }

    func saveRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {

        let row = WeeklyGameRegistrationRow.fromDomain(registration)

        try await client
            .from("weekly_game_registrations")
            .insert(row)
            .execute()
    }

    func updateRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {

        let row = WeeklyGameRegistrationRow.fromDomain(registration)

        try await client
            .from("weekly_game_registrations")
            .update(row)
            .eq("id", value: registration.id.uuidString)
            .execute()
    }
}
