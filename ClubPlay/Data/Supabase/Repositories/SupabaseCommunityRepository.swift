//
//  SupabaseCommunityRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Supabase

final class SupabaseCommunityRepository: CommunityRepository {
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }

    func fetchCommunity(id: UUID) async throws -> Community? {
        let rows: [CommunityRow] = try await client
            .from("communities")
            .select()
            .eq("id", value: id.uuidString)
            .limit(1)
            .execute()
            .value

        return rows.first?.toDomain()
    }

    func createCommunity(_ community: Community) async throws {
        let row = CommunityRow(
            id: community.id,
            name: community.name,
            createdAt: community.createdAt,
            createdBy: community.createdByMemberID
        )

        try await client
            .from("communities")
            .insert(row)
            .execute()
    }

    func updateCommunity(_ community: Community) async throws {
        let row = CommunityRow(
            id: community.id,
            name: community.name,
            createdAt: community.createdAt,
            createdBy: community.createdByMemberID
        )

        try await client
            .from("communities")
            .update(row)
            .eq("id", value: community.id.uuidString)
            .execute()
    }
}