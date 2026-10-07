//
//  CreateGameUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("CreateGameUseCase")
struct CreateGameUseCaseTests {

    @Test("Organiser creates a valid game successfully")
    func organiserCreatesValidGame() async throws {
        let now = Date()
        let organiserID = UUID()
        let communityID = UUID()

        let game = makeGame(
            communityID: communityID,
            currentDate: now
        )

        let gameRepository =
            MockWeeklyFootballGameRepository()

        let membershipRepository =
            MockCommunityMembershipRepository()

        membershipRepository.memberships = [
            CommunityMembership(
                id: UUID(),
                memberID: organiserID,
                communityID: communityID,
                role: .organiser,
                joinedAt: now
            )
        ]

        let useCase = CreateGameUseCase(
            gameRepository: gameRepository,
            membershipRepository:
                membershipRepository
        )

        try await useCase.execute(
            game: game,
            requestingMemberID: organiserID
        )

        #expect(gameRepository.games.count == 1)
        #expect(gameRepository.games.first?.id == game.id)
    }

    @Test("Non-organiser cannot create a game")
    func nonOrganiserCannotCreateGame() async throws {
        let now = Date()
        let memberID = UUID()
        let communityID = UUID()

        let game = makeGame(
            communityID: communityID,
            currentDate: now
        )

        let gameRepository =
            MockWeeklyFootballGameRepository()

        let membershipRepository =
            MockCommunityMembershipRepository()

        membershipRepository.memberships = [
            CommunityMembership(
                id: UUID(),
                memberID: memberID,
                communityID: communityID,
                role: .member,
                joinedAt: now
            )
        ]

        let useCase = CreateGameUseCase(
            gameRepository: gameRepository,
            membershipRepository:
                membershipRepository
        )

        do {
            try await useCase.execute(
                game: game,
                requestingMemberID: memberID
            )

            Issue.record(
                "Expected unauthorised error"
            )

        } catch let error as GameManagementError {
            #expect(error == .unauthorised)
        }

        #expect(gameRepository.games.isEmpty)
    }
}

private func makeGame(
    communityID: UUID,
    currentDate: Date
) -> WeeklyFootballGame {

    let kickOffAt =
        currentDate.addingTimeInterval(7200)

    return WeeklyFootballGame(
        id: UUID(),
        communityID: communityID,
        gameName: "Sunday Football",
        venueName: "UTS Sports Hall",
        kickOffAt: kickOffAt,
        finishesAt:
            kickOffAt.addingTimeInterval(3600),
        playerCapacity: 10,
        registrationOpensAt:
            currentDate.addingTimeInterval(-3600),
        registrationClosesAt:
            kickOffAt.addingTimeInterval(-1800),
        cancellationDeadlineHours: 2,
        status: .draft,
        createdAt: currentDate,
        createdByMemberID: UUID()
    )
}
