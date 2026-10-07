//
//  EditGameUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("EditGameUseCase")
struct EditGameUseCaseTests {

    @Test("Non-organiser cannot edit a game")
    func nonOrganiserCannotEditGame() async throws {
        let now = Date()
        let memberID = UUID()
        let communityID = UUID()

        let existingGame = makePublishedGame(
            communityID: communityID,
            currentDate: now
        )

        var editedGame = existingGame
        editedGame.venueName = "New Venue"

        let gameRepository =
            MockWeeklyFootballGameRepository()
        gameRepository.games = [existingGame]

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

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        let notificationRepository =
            MockNotificationRepository()

        let useCase = EditGameUseCase(
            gameRepository: gameRepository,
            membershipRepository: membershipRepository,
            registrationRepository: registrationRepository,
            notificationRepository: notificationRepository
        )

        do {
            try await useCase.execute(
                game: editedGame,
                requestingMemberID: memberID
            )

            Issue.record(
                "Expected unauthorised error"
            )

        } catch let error as GameManagementError {
            #expect(error == .unauthorised)
        }

        #expect(
            notificationRepository.sentNotifications.isEmpty
        )
    }

    @Test("Updating a published game notifies registered players")
    func publishedGameUpdateNotifiesPlayers() async throws {
        let now = Date()
        let organiserID = UUID()
        let playerID = UUID()
        let communityID = UUID()

        let existingGame = makePublishedGame(
            communityID: communityID,
            currentDate: now
        )

        var editedGame = existingGame
        editedGame.venueName = "UTS Sports Hall 2"

        let gameRepository =
            MockWeeklyFootballGameRepository()
        gameRepository.games = [existingGame]

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

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()
        registrationRepository.registrations = [
            WeeklyGameRegistration(
                id: UUID(),
                memberID: playerID,
                gameID: existingGame.id,
                registrationStatus: .confirmed,
                attendanceStatus: .absent,
                registeredAt: now,
                updatedAt: now
            )
        ]

        let notificationRepository =
            MockNotificationRepository()

        let useCase = EditGameUseCase(
            gameRepository: gameRepository,
            membershipRepository: membershipRepository,
            registrationRepository: registrationRepository,
            notificationRepository: notificationRepository
        )

        try await useCase.execute(
            game: editedGame,
            requestingMemberID: organiserID
        )

        #expect(
            notificationRepository.sentNotifications.count == 1
        )

        let notification =
            try #require(
                notificationRepository.sentNotifications.first
            )

        #expect(notification.type == .gameUpdated)
        #expect(
            notification.recipientMemberIDs == [playerID]
        )
        #expect(
            notification.previousVenueName
                == existingGame.venueName
        )
        #expect(
            notification.updatedVenueName
                == editedGame.venueName
        )
    }
}

private func makePublishedGame(
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
        status: .published,
        createdAt: currentDate,
        createdByMemberID: UUID()
    )
}
