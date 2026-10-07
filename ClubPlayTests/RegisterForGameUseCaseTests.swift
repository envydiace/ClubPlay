//
//  RegisterForGameUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("RegisterForGameUseCase")
struct RegisterForGameUseCaseTests {

    @Test("Registers as confirmed when capacity is available")
    func registersAsConfirmed() async throws {
        let now = Date()
        let memberID = UUID()

        let game = makeGame(
            capacity: 2,
            currentDate: now
        )

        let gameRepository =
            MockWeeklyFootballGameRepository()

        gameRepository.games = [game]

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        let useCase = RegisterForGameUseCase(
            gameRepository: gameRepository,
            registrationRepository:
                registrationRepository
        )

        let result = try await useCase.execute(
            memberID: memberID,
            gameID: game.id,
            currentDate: now
        )

        #expect(
            result.registrationStatus == .confirmed
        )

        #expect(
            registrationRepository.registrations.count == 1
        )

        #expect(
            registrationRepository.registrations.first?.memberID
                == memberID
        )
    }

    @Test("Registers as waitlisted when capacity is full")
    func registersAsWaitlisted() async throws {
        let now = Date()

        let game = makeGame(
            capacity: 1,
            currentDate: now
        )

        let existingRegistration =
            WeeklyGameRegistration(
                id: UUID(),
                memberID: UUID(),
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
            existingRegistration
        ]

        let useCase = RegisterForGameUseCase(
            gameRepository: gameRepository,
            registrationRepository:
                registrationRepository
        )

        let result = try await useCase.execute(
            memberID: UUID(),
            gameID: game.id,
            currentDate: now
        )

        #expect(
            result.registrationStatus == .waitlisted
        )

        #expect(
            registrationRepository.registrations.count == 2
        )
    }
    
    @Test("Throws duplicateRegistration when member is already registered")
    func duplicateRegistrationThrows() async throws {
        let now = Date()
        let memberID = UUID()

        let game = makeGame(
            capacity: 5,
            currentDate: now
        )

        let existingRegistration =
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
            existingRegistration
        ]

        let useCase = RegisterForGameUseCase(
            gameRepository: gameRepository,
            registrationRepository:
                registrationRepository
        )

        do {
            _ = try await useCase.execute(
                memberID: memberID,
                gameID: game.id,
                currentDate: now
            )

            Issue.record("Expected duplicateRegistration error")

        } catch let error as RegistrationError {
            #expect(error == .duplicateRegistration)
        }
    }
    
    @Test("Throws registrationNotOpen before registration opens")
    func registrationNotOpenThrows() async throws {
        let now = Date()

        var game = makeGame(
            capacity: 5,
            currentDate: now
        )

        game.registrationOpensAt =
            now.addingTimeInterval(3600)

        let gameRepository =
            MockWeeklyFootballGameRepository()
        gameRepository.games = [game]

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        let useCase = RegisterForGameUseCase(
            gameRepository: gameRepository,
            registrationRepository:
                registrationRepository
        )

        do {
            _ = try await useCase.execute(
                memberID: UUID(),
                gameID: game.id,
                currentDate: now
            )

            Issue.record("Expected registrationNotOpen error")

        } catch let error as RegistrationError {
            #expect(error == .registrationNotOpen)
        }
    }
}

private func makeGame(
    capacity: Int,
    currentDate: Date
) -> WeeklyFootballGame {

    WeeklyFootballGame(
        id: UUID(),
        communityID: UUID(),
        gameName: "Sunday Football",
        venueName: "UTS Sports Hall",
        kickOffAt:
            currentDate.addingTimeInterval(7200),
        finishesAt:
            currentDate.addingTimeInterval(10800),
        playerCapacity: capacity,
        registrationOpensAt:
            currentDate.addingTimeInterval(-3600),
        registrationClosesAt:
            currentDate.addingTimeInterval(3600),
        cancellationDeadlineHours: 2,
        status: .published,
        createdAt: currentDate,
        createdByMemberID: UUID()
    )
}
