//
//  MarkAttendanceUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("MarkAttendanceUseCase")
struct MarkAttendanceUseCaseTests {

    @Test("Organiser marks a confirmed player as present when attendance is open")
    func organiserMarksConfirmedPlayerPresent() async throws {
        let now = Date()
        let organiserID = UUID()
        let playerID = UUID()
        let communityID = UUID()
        let gameID = UUID()
        let registrationID = UUID()

        let kickOffAt =
            now.addingTimeInterval(3600)

        let game = WeeklyFootballGame(
            id: gameID,
            communityID: communityID,
            gameName: "Sunday Football",
            venueName: "UTS Sports Hall",
            kickOffAt: kickOffAt,
            finishesAt: kickOffAt.addingTimeInterval(3600),
            playerCapacity: 10,
            registrationOpensAt:
                now.addingTimeInterval(-86400),
            registrationClosesAt:
                now.addingTimeInterval(-1800),
            cancellationDeadlineHours: 2,
            status: .published,
            createdAt: now,
            createdByMemberID: organiserID
        )

        let registration =
            WeeklyGameRegistration(
                id: registrationID,
                memberID: playerID,
                gameID: gameID,
                registrationStatus: .confirmed,
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

        let useCase = MarkAttendanceUseCase(
            registrationRepository:
                registrationRepository,
            gameRepository:
                gameRepository,
            membershipRepository:
                membershipRepository
        )

        let result = try await useCase.execute(
            registrationID: registrationID,
            attendanceStatus: .present,
            requestingMemberID: organiserID,
            currentDate: now
        )

        #expect(result.attendanceStatus == .present)

        let updatedRegistration =
            registrationRepository.registrations.first {
                $0.id == registrationID
            }

        #expect(
            updatedRegistration?.attendanceStatus
                == .present
        )
    }

    @Test("Non-organiser cannot mark attendance")
    func nonOrganiserCannotMarkAttendance() async throws {
        let now = Date()
        let memberID = UUID()
        let playerID = UUID()
        let communityID = UUID()
        let gameID = UUID()
        let registrationID = UUID()

        let kickOffAt =
            now.addingTimeInterval(3600)

        let game = WeeklyFootballGame(
            id: gameID,
            communityID: communityID,
            gameName: "Sunday Football",
            venueName: "UTS Sports Hall",
            kickOffAt: kickOffAt,
            finishesAt:
                kickOffAt.addingTimeInterval(3600),
            playerCapacity: 10,
            registrationOpensAt:
                now.addingTimeInterval(-86400),
            registrationClosesAt:
                now.addingTimeInterval(-1800),
            cancellationDeadlineHours: 2,
            status: .published,
            createdAt: now,
            createdByMemberID: UUID()
        )

        let registration =
            WeeklyGameRegistration(
                id: registrationID,
                memberID: playerID,
                gameID: gameID,
                registrationStatus: .confirmed,
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
                memberID: memberID,
                communityID: communityID,
                role: .member,
                joinedAt: now
            )
        ]

        let useCase = MarkAttendanceUseCase(
            registrationRepository:
                registrationRepository,
            gameRepository:
                gameRepository,
            membershipRepository:
                membershipRepository
        )

        do {
            _ = try await useCase.execute(
                registrationID: registrationID,
                attendanceStatus: .present,
                requestingMemberID: memberID,
                currentDate: now
            )

            Issue.record(
                "Expected unauthorised attendance error"
            )

        } catch let error as AttendanceError {
            #expect(error == .unauthorised)
        }
    }
}