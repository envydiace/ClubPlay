//
//  PreviewAuthRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//

import Foundation

final class PreviewAuthRepository: AuthRepository {
    private var signedInUserID: UUID?

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

final class PreviewGameRepository: WeeklyFootballGameRepository {

    func fetchUpcomingGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {
        MockData.upcomingGames
    }

    func fetchGames(
        communityID: UUID
    ) async throws -> [WeeklyFootballGame] {
        MockData.upcomingGames
    }

    func fetchGame(
        id: UUID
    ) async throws -> WeeklyFootballGame? {
        MockData.upcomingGames.first {
            $0.id == id
        }
    }

    func createGame(
        _ game: WeeklyFootballGame
    ) async throws {
        // Preview only
    }

    func updateGame(
        _ game: WeeklyFootballGame
    ) async throws {
        // Preview only
    }
}

final class PreviewRegistrationRepository:
    WeeklyGameRegistrationRepository {

    func fetchRegistration(
        id: UUID
    ) async throws -> WeeklyGameRegistration? {
        MockData.registrations.first {
            $0.id == id
        }
    }

    func fetchRegistration(
        memberID: UUID,
        gameID: UUID
    ) async throws -> WeeklyGameRegistration? {
        MockData.registrations.first {
            $0.memberID == memberID &&
            $0.gameID == gameID
        }
    }

    func fetchRegistrations(
        forGameID gameID: UUID
    ) async throws -> [WeeklyGameRegistration] {
        MockData.registrations.filter {
            $0.gameID == gameID
        }
    }

    func fetchRegistrations(
        forMemberID memberID: UUID
    ) async throws -> [WeeklyGameRegistration] {
        MockData.registrations.filter {
            $0.memberID == memberID
        }
    }

    func saveRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {
        // Preview only
    }

    func updateRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {
        // Preview only
    }

    func promoteNextWaitlistedPlayer(
        gameID: UUID
    ) async throws -> UUID? {
        nil
    }
}
