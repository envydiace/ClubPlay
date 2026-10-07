//
//  MockCommunityMembershipRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//

import Foundation
@testable import ClubPlay

@MainActor
final class MockCommunityMembershipRepository:
    CommunityMembershipRepository {

    var memberships: [CommunityMembership] = []

    func fetchMembership(
        memberID: UUID,
        communityID: UUID
    ) async throws -> CommunityMembership? {
        memberships.first {
            $0.memberID == memberID &&
            $0.communityID == communityID
        }
    }

    func fetchMemberships(
        forCommunityID communityID: UUID
    ) async throws -> [CommunityMembership] {
        memberships.filter {
            $0.communityID == communityID
        }
    }

    func fetchMemberships(
        forMemberID memberID: UUID
    ) async throws -> [CommunityMembership] {
        memberships.filter {
            $0.memberID == memberID
        }
    }

    func createMembership(
        _ membership: CommunityMembership
    ) async throws {
        memberships.append(membership)
    }

    func updateMembership(
        _ membership: CommunityMembership
    ) async throws {
        guard let index = memberships.firstIndex(
            where: { $0.id == membership.id }
        ) else {
            return
        }

        memberships[index] = membership
    }
}
