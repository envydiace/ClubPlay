//
//  CancelGameRegistrationUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("CancelGameRegistrationUseCase")
struct CancelGameRegistrationUseCaseTests {

    @Test("Cancels registration before cancellation deadline")
    func cancelsBeforeDeadline() async throws {
        let now = Date()
        let memberID = UUID()

        let game = makeGame(
            kickOffAt: now.addingTimeInterval(7200)
        )

        let registration = WeeklyGameRegistration(
            id: UUID(),
            memberID: memberID,
            gameID: game.id,
            registrationStatus: .confirmed,
            attendanceStatus: .absent,
            registeredAt: now,
            updatedAt: now
        )

        let gameRepository =
            MockWeeklyFootballGameRepository()
        gameRepository.games = [game]

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()
        registrationRepository.registrations = [
            registration
        ]

        let promoteUseCase =
            PromoteWaitlistedPlayerUseCase(
                registrationRepository:
                    registrationRepository
            )

        let useCase =
            CancelGameRegistrationUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository,
                promoteWaitlistedPlayerUseCase:
                    promoteUseCase
            )

        let result = try await useCase.execute(
            memberID: memberID,
            gameID: game.id,
            currentDate: now
        )

        #expect(
            result.registrationStatus == .cancelled
        )

        #expect(
            registrationRepository
                .registrations
                .first?
                .registrationStatus == .cancelled
        )
    }

    @Test("Throws when cancellation deadline has passed")
    func deadlinePassedThrows() async throws {
        let now = Date()
        let memberID = UUID()

        let game = makeGame(
            kickOffAt: now.addingTimeInterval(3600)
        )

        let registration = WeeklyGameRegistration(
            id: UUID(),
            memberID: memberID,
            gameID: game.id,
            registrationStatus: .confirmed,
            attendanceStatus: .absent,
            registeredAt: now,
            updatedAt: now
        )

        let gameRepository =
            MockWeeklyFootballGameRepository()
        gameRepository.games = [game]

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()
        registrationRepository.registrations = [
            registration
        ]

        let promoteUseCase =
            PromoteWaitlistedPlayerUseCase(
                registrationRepository:
                    registrationRepository
            )

        let useCase =
            CancelGameRegistrationUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository,
                promoteWaitlistedPlayerUseCase:
                    promoteUseCase
            )

        do {
            _ = try await useCase.execute(
                memberID: memberID,
                gameID: game.id,
                currentDate: now
            )

            Issue.record(
                "Expected cancellationDeadlinePassed"
            )

        } catch let error as RegistrationError {
            #expect(
                error == .cancellationDeadlinePassed
            )
        }
    }
    
    @Test("Allows cancellation exactly at the cancellation deadline")
    func cancelsExactlyAtDeadline() async throws {
        let now = Date()
        let memberID = UUID()

        let kickOffAt =
            now.addingTimeInterval(2 * 3600)

        let game = makeGame(
            kickOffAt: kickOffAt
        )

        let registration =
            WeeklyGameRegistration(
                id: UUID(),
                memberID: memberID,
                gameID: game.id,
                registrationStatus: .confirmed,
                attendanceStatus: .absent,
                registeredAt: now,
                updatedAt: now
            )

        let gameRepository =
            MockWeeklyFootballGameRepository()

        gameRepository.games = [game]

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        registrationRepository.registrations = [
            registration
        ]

        let promoteUseCase =
            PromoteWaitlistedPlayerUseCase(
                registrationRepository:
                    registrationRepository
            )

        let useCase =
            CancelGameRegistrationUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository,
                promoteWaitlistedPlayerUseCase:
                    promoteUseCase
            )

        let result = try await useCase.execute(
            memberID: memberID,
            gameID: game.id,
            currentDate: now
        )

        #expect(
            result.registrationStatus == .cancelled
        )
    }
    
    @Test("Promotes next waitlisted player when confirmed player cancels")
    func promotesNextWaitlistedPlayer() async throws {
        let now = Date()

        let confirmedMemberID = UUID()
        let waitlistedMemberID = UUID()

        let game = makeGame(
            kickOffAt: now.addingTimeInterval(3 * 3600)
        )

        let confirmedRegistration =
            WeeklyGameRegistration(
                id: UUID(),
                memberID: confirmedMemberID,
                gameID: game.id,
                registrationStatus: .confirmed,
                attendanceStatus: .absent,
                registeredAt: now.addingTimeInterval(-600),
                updatedAt: now
            )

        let waitlistedRegistration =
            WeeklyGameRegistration(
                id: UUID(),
                memberID: waitlistedMemberID,
                gameID: game.id,
                registrationStatus: .waitlisted,
                attendanceStatus: .absent,
                registeredAt: now.addingTimeInterval(-300),
                updatedAt: now
            )

        let gameRepository =
            MockWeeklyFootballGameRepository()

        gameRepository.games = [game]

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        registrationRepository.registrations = [
            confirmedRegistration,
            waitlistedRegistration
        ]

        registrationRepository.promotedMemberID =
            waitlistedMemberID

        let promoteUseCase =
            PromoteWaitlistedPlayerUseCase(
                registrationRepository:
                    registrationRepository
            )

        let useCase =
            CancelGameRegistrationUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository,
                promoteWaitlistedPlayerUseCase:
                    promoteUseCase
            )

        let result = try await useCase.execute(
            memberID: confirmedMemberID,
            gameID: game.id,
            currentDate: now
        )

        #expect(
            result.registrationStatus == .cancelled
        )

        #expect(
            registrationRepository.promotedMemberID
                == waitlistedMemberID
        )
        
        #expect(
            registrationRepository
                .promoteNextWaitlistedPlayerCalled
        )
    }
}

private func makeGame(
    kickOffAt: Date
) -> WeeklyFootballGame {

    WeeklyFootballGame(
        id: UUID(),
        communityID: UUID(),
        gameName: "Sunday Football",
        venueName: "UTS Sports Hall",
        kickOffAt: kickOffAt,
        finishesAt:
            kickOffAt.addingTimeInterval(3600),
        playerCapacity: 10,
        registrationOpensAt:
            kickOffAt.addingTimeInterval(-86400),
        registrationClosesAt:
            kickOffAt.addingTimeInterval(-1800),
        cancellationDeadlineHours: 2,
        status: .published,
        createdAt: Date(),
        createdByMemberID: UUID()
    )
}
