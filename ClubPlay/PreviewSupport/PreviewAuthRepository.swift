//
//  PreviewAuthRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//

import Foundation

final class PreviewAuthRepository: AuthRepository {
    private var signedInUserID: UUID?

    func signUp(
        email: String,
        password: String,
        fullName: String
    ) async throws -> UUID {
        signedInUserID = MockData.memberID
        return MockData.memberID
    }

    func signIn(
        email: String,
        password: String
    ) async throws -> UUID {
        signedInUserID = MockData.memberID
        return MockData.memberID
    }

    func signOut() async throws {
        signedInUserID = nil
    }

    func currentUserID() async throws -> UUID? {
        signedInUserID
    }
}

final class PreviewClubMemberRepository: ClubMemberRepository {

    func fetchMember(
        id: UUID
    ) async throws -> ClubMember? {
        MockData.member
    }

    func createMember(
        _ member: ClubMember
    ) async throws {
        // Preview only — no persistence.
    }

    func updateMember(
        _ member: ClubMember
    ) async throws {
        // Preview only — no persistence.
    }
}

final class PreviewCommunityRepository: CommunityRepository {

    func fetchCommunity(
        id: UUID
    ) async throws -> Community? {
        MockData.community
    }

    func createCommunity(
        _ community: Community
    ) async throws {
        // Preview only.
    }

    func updateCommunity(
        _ community: Community
    ) async throws {
        // Preview only.
    }
}

final class PreviewCommunityMembershipRepository:
    CommunityMembershipRepository {

    func fetchMembership(
        memberID: UUID,
        communityID: UUID
    ) async throws -> CommunityMembership? {
        MockData.organiserMembership
    }

    func fetchMemberships(
        forCommunityID communityID: UUID
    ) async throws -> [CommunityMembership] {
        [MockData.organiserMembership]
    }

    func fetchMemberships(
        forMemberID memberID: UUID
    ) async throws -> [CommunityMembership] {
        [MockData.organiserMembership]
    }

    func createMembership(
        _ membership: CommunityMembership
    ) async throws {
        // Preview only.
    }

    func updateMembership(
        _ membership: CommunityMembership
    ) async throws {
        // Preview only.
    }
}
