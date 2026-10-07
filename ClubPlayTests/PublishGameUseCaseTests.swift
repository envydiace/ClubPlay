//
//  PublishGameUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("PublishGameUseCase")
struct PublishGameUseCaseTests {

    @Test("Organiser publishes a valid draft game")
    func organiserPublishesDraftGame() async throws {
        let now = Date()
        let organiserID = UUID()
        let communityID = UUID()

        let game = makeDraftGame(
            communityID: communityID,
            currentDate: now
        )

        let gameRepository =
            MockWeeklyFootballGameRepository()
        gameRepository.games = [game]

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

        let useCase = PublishGameUseCase(
            gameRepository: gameRepository,
            membershipRepository:
                membershipRepository
        )

        try await useCase.execute(
            gameID: game.id,
            requestingMemberID: organiserID
        )

        let updatedGame =
            gameRepository.games.first {
                $0.id == game.id
            }

        #expect(
            updatedGame?.status == .published
        )
    }

    @Test("Non-organiser cannot publish a game")
    func nonOrganiserCannotPublishGame() async throws {
        let now = Date()
        let memberID = UUID()
        let communityID = UUID()

        let game = makeDraftGame(
            communityID: communityID,
            currentDate: now
        )

        let gameRepository =
            MockWeeklyFootballGameRepository()
        gameRepository.games = [game]

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

        let useCase = PublishGameUseCase(
            gameRepository: gameRepository,
            membershipRepository:
                membershipRepository
        )

        do {
            try await useCase.execute(
                gameID: game.id,
                requestingMemberID: memberID
            )

            Issue.record(
                "Expected unauthorised error"
            )

        } catch let error as GameManagementError {
            #expect(error == .unauthorised)
        }

        #expect(
            gameRepository.games.first?.status
                == .draft
        )
    }
}

private func makeDraftGame(
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
        createdByMemberID: organiserPlaceholderID()
    )
}

private func organiserPlaceholderID() -> UUID {
    UUID()
}
