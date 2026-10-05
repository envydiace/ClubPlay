//
//  SupabaseCommunityMembershipRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Supabase

final class SupabaseCommunityMembershipRepository:
    CommunityMembershipRepository {

    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }

    func fetchMembership(
        memberID: UUID,
        communityID: UUID
    ) async throws -> CommunityMembership? {

        let rows: [CommunityMembershipRow] = try await client
            .from("community_memberships")
            .select()
            .eq("member_id", value: memberID.uuidString)
            .eq("community_id", value: communityID.uuidString)
            .limit(1)
            .execute()
            .value

        return rows.first?.toDomain()
    }

    func fetchMemberships(
        forCommunityID communityID: UUID
    ) async throws -> [CommunityMembership] {

        let rows: [CommunityMembershipRow] = try await client
            .from("community_memberships")
            .select()
            .eq("community_id", value: communityID.uuidString)
            .execute()
            .value

        return rows.map { $0.toDomain() }
    }
    
    func fetchMemberships(
        forMemberID memberID: UUID
    ) async throws -> [CommunityMembership] {
        let rows: [CommunityMembershipRow] = try await client
            .from("community_memberships")
            .select()
            .eq("member_id", value: memberID.uuidString)
            .execute()
            .value

        return rows.map { $0.toDomain() }
    }

    func createMembership(
        _ membership: CommunityMembership
    ) async throws {

        let row = CommunityMembershipRow(
            id: membership.id,
            memberID: membership.memberID,
            communityID: membership.communityID,
            role: membership.role.rawValue,
            joinedAt: membership.joinedAt
        )

        try await client
            .from("community_memberships")
            .insert(row)
            .execute()
    }

    func updateMembership(
        _ membership: CommunityMembership
    ) async throws {

        let row = CommunityMembershipRow(
            id: membership.id,
            memberID: membership.memberID,
            communityID: membership.communityID,
            role: membership.role.rawValue,
            joinedAt: membership.joinedAt
        )

        try await client
            .from("community_memberships")
            .update(row)
            .eq("id", value: membership.id.uuidString)
            .execute()
    }
}
