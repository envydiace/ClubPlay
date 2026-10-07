//
//  ChangeRegistrationStatusUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("ChangeRegistrationStatusUseCase")
struct ChangeRegistrationStatusUseCaseTests {

    @Test("Organiser changes a player's registration from waitlisted to confirmed")
    func organiserChangesRegistrationToConfirmed() async throws {
        let now = Date()
        let organiserID = UUID()
        let playerID = UUID()
        let communityID = UUID()
        let gameID = UUID()
        let registrationID = UUID()

        let game = WeeklyFootballGame(
            id: gameID,
            communityID: communityID,
            gameName: "Sunday Football",
            venueName: "UTS Sports Hall",
            kickOffAt: now.addingTimeInterval(7200),
            finishesAt: now.addingTimeInterval(10800),
            playerCapacity: 10,
            registrationOpensAt: now.addingTimeInterval(-3600),
            registrationClosesAt: now.addingTimeInterval(3600),
            cancellationDeadlineHours: 2,
            status: .published,
            createdAt: now,
            createdByMemberID: organiserID
        )

        let registration = WeeklyGameRegistration(
            id: registrationID,
            memberID: playerID,
            gameID: gameID,
            registrationStatus: .waitlisted,
            attendanceStatus: .absent,
            registeredAt: now,
            updatedAt: now
        )

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        registrationRepository.registrations = [
            registration
        ]

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

        let useCase = ChangeRegistrationStatusUseCase(
            registrationRepository:
                registrationRepository,
            membershipRepository:
                membershipRepository,
            gameRepository:
                gameRepository
        )

        let result = try await useCase.execute(
            registrationID: registrationID,
            newStatus: .confirmed,
            requestingMemberID: organiserID,
            currentDate: now
        )

        #expect(
            result.registrationStatus == .confirmed
        )

        let updatedRegistration =
            registrationRepository.registrations.first {
                $0.id == registrationID
            }

        #expect(
            updatedRegistration?.registrationStatus
                == .confirmed
        )
    }

    @Test("Organiser cannot change a registration directly to cancelled")
    func invalidStatusChangeThrows() async throws {
        let now = Date()
        let organiserID = UUID()
        let communityID = UUID()
        let gameID = UUID()
        let registrationID = UUID()

        let game = WeeklyFootballGame(
            id: gameID,
            communityID: communityID,
            gameName: "Sunday Football",
            venueName: "UTS Sports Hall",
            kickOffAt: now.addingTimeInterval(7200),
            finishesAt: now.addingTimeInterval(10800),
            playerCapacity: 10,
            registrationOpensAt: now.addingTimeInterval(-3600),
            registrationClosesAt: now.addingTimeInterval(3600),
            cancellationDeadlineHours: 2,
            status: .published,
            createdAt: now,
            createdByMemberID: organiserID
        )

        let registration = WeeklyGameRegistration(
            id: registrationID,
            memberID: UUID(),
            gameID: gameID,
            registrationStatus: .waitlisted,
            attendanceStatus: .absent,
            registeredAt: now,
            updatedAt: now
        )

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        registrationRepository.registrations = [
            registration
        ]

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

        let useCase = ChangeRegistrationStatusUseCase(
            registrationRepository:
                registrationRepository,
            membershipRepository:
                membershipRepository,
            gameRepository:
                gameRepository
        )

        do {
            _ = try await useCase.execute(
                registrationID: registrationID,
                newStatus: .cancelled,
                requestingMemberID: organiserID,
                currentDate: now
            )

            Issue.record(
                "Expected invalidStatusChange error"
            )

        } catch let error as RegistrationError {
            #expect(error == .invalidStatusChange)
        }
    }
}