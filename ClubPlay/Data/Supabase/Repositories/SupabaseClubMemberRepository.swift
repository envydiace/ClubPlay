//
//  SupabaseClubMemberRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Supabase

final class SupabaseClubMemberRepository: ClubMemberRepository {
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }

    func fetchMember(id: UUID) async throws -> ClubMember? {
        let rows: [ProfileRow] = try await client
            .from("profiles")
            .select()
            .eq("id", value: id.uuidString)
            .limit(1)
            .execute()
            .value

        return rows.first?.toDomain()
    }
}