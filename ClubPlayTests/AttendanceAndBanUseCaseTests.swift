//
//  AttendanceAndBanUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//

import Foundation
import Testing
@testable import ClubPlay

@MainActor
struct AttendanceAndBanUseCaseTests {
    
    @Test
    func organiserCanMarkConfirmedPlayerPresentAfterAttendanceOpens() async throws {
        let gameRepository = MockWeeklyFootballGameRepository()
        let registrationRepository = MockWeeklyGameRegistrationRepository()
        let membershipRepository = MockCommunityMembershipRepository()
        
        let communityID = UUID()
        let organiserID = UUID()
        let memberID = UUID()
        let gameID = UUID()
        let registrationID = UUID()
        
        let kickOff = Date(timeIntervalSince1970: 1_800_000_000)
        
        gameRepository.games = [
            WeeklyFootballGame(
                id: gameID,
                communityID: communityID,
                gameName: "Sunday Football",
                venueName: "UTS Field",
                kickOffAt: kickOff,
                finishesAt: kickOff.addingTimeInterval(2 * 60 * 60),
                playerCapacity: 16,
                registrationOpensAt: kickOff.addingTimeInterval(-7 * 24 * 60 * 60),
                registrationClosesAt: kickOff.addingTimeInterval(-60 * 60),
                cancellationDeadlineHours: 2,
                status: .published,
                createdAt: Date(),
                createdByMemberID: organiserID
            )
        ]
        
        membershipRepository.memberships = [
            CommunityMembership(
                id: UUID(),
                memberID: organiserID,
                communityID: communityID,
                role: .organiser,
                joinedAt: Date()
            )
        ]
        
        registrationRepository.registrations = [
            WeeklyGameRegistration(
                id: registrationID,
                memberID: memberID,
                gameID: gameID,
                registrationStatus: .confirmed,
                attendanceStatus: .absent,
                registeredAt: Date(),
                updatedAt: Date()
            )
        ]
        
        let useCase = MarkAttendanceUseCase(
            registrationRepository: registrationRepository,
            gameRepository: gameRepository,
            membershipRepository: membershipRepository
        )
        
        let result = try await useCase.execute(
            registrationID: registrationID,
            attendanceStatus: .present,
            requestingMemberID: organiserID,
            currentDate: kickOff.addingTimeInterval(-60 * 60)
        )
        
        #expect(result.attendanceStatus == .present)
    }
    
    @Test
    func attendanceCannotBeMarkedBeforeAttendanceOpens() async throws {
        let gameRepository = MockWeeklyFootballGameRepository()
        let registrationRepository = MockWeeklyGameRegistrationRepository()
        let membershipRepository = MockCommunityMembershipRepository()
        
        let communityID = UUID()
        let organiserID = UUID()
        let memberID = UUID()
        let gameID = UUID()
        let registrationID = UUID()
        
        let kickOff = Date(timeIntervalSince1970: 1_800_000_000)
        
        gameRepository.games = [
            WeeklyFootballGame(
                id: gameID,
                communityID: communityID,
                gameName: "Sunday Football",
                venueName: "UTS Field",
                kickOffAt: kickOff,
                finishesAt: kickOff.addingTimeInterval(2 * 60 * 60),
                playerCapacity: 16,
                registrationOpensAt: kickOff.addingTimeInterval(-7 * 24 * 60 * 60),
                registrationClosesAt: kickOff.addingTimeInterval(-60 * 60),
                cancellationDeadlineHours: 2,
                status: .published,
                createdAt: Date(),
                createdByMemberID: organiserID
            )
        ]
        
        membershipRepository.memberships = [
            CommunityMembership(
                id: UUID(),
                memberID: organiserID,
                communityID: communityID,
                role: .organiser,
                joinedAt: Date()
            )
        ]
        
        registrationRepository.registrations = [
            WeeklyGameRegistration(
                id: registrationID,
                memberID: memberID,
                gameID: gameID,
                registrationStatus: .confirmed,
                attendanceStatus: .absent,
                registeredAt: Date(),
                updatedAt: Date()
            )
        ]
        
        let useCase = MarkAttendanceUseCase(
            registrationRepository: registrationRepository,
            gameRepository: gameRepository,
            membershipRepository: membershipRepository
        )
        
        await #expect(throws: AttendanceError.attendanceNotOpen) {
            try await useCase.execute(
                registrationID: registrationID,
                attendanceStatus: .present,
                requestingMemberID: organiserID,
                currentDate: kickOff.addingTimeInterval(-3 * 60 * 60)
            )
        }
    }
    
    @Test
    func closingFinishedGameCreatesBanForSelectedAbsentPlayer() async throws {
        let gameRepository = MockWeeklyFootballGameRepository()
        let registrationRepository = MockWeeklyGameRegistrationRepository()
        let membershipRepository = MockCommunityMembershipRepository()
        let banRepository = MockMemberBanRepository()
        
        let communityID = UUID()
        let organiserID = UUID()
        let absentMemberID = UUID()
        let gameID = UUID()
        
        let finishDate = Date(timeIntervalSince1970: 1_800_000_000)
        let currentDate = finishDate.addingTimeInterval(60)
        
        gameRepository.games = [
            WeeklyFootballGame(
                id: gameID,
                communityID: communityID,
                gameName: "Sunday Football",
                venueName: "UTS Field",
                kickOffAt: finishDate.addingTimeInterval(-2 * 60 * 60),
                finishesAt: finishDate,
                playerCapacity: 16,
                registrationOpensAt: finishDate.addingTimeInterval(-7 * 24 * 60 * 60),
                registrationClosesAt: finishDate.addingTimeInterval(-3 * 60 * 60),
                cancellationDeadlineHours: 2,
                status: .published,
                createdAt: Date(),
                createdByMemberID: organiserID
            )
        ]
        
        membershipRepository.memberships = [
            CommunityMembership(
                id: UUID(),
                memberID: organiserID,
                communityID: communityID,
                role: .organiser,
                joinedAt: Date()
            )
        ]
        
        registrationRepository.registrations = [
            WeeklyGameRegistration(
                id: UUID(),
                memberID: absentMemberID,
                gameID: gameID,
                registrationStatus: .confirmed,
                attendanceStatus: .absent,
                registeredAt: Date(),
                updatedAt: Date()
            )
        ]
        
        let useCase = CloseGameUseCase(
            gameRepository: gameRepository,
            registrationRepository: registrationRepository,
            membershipRepository: membershipRepository,
            banRepository: banRepository
        )
        
        try await useCase.execute(
            gameID: gameID,
            requestingMemberID: organiserID,
            membersToBan: [absentMemberID],
            banUntil: currentDate.addingTimeInterval(14 * 24 * 60 * 60),
            currentDate: currentDate
        )
        
        #expect(banRepository.bans.count == 1)
        #expect(banRepository.bans.first?.memberID == absentMemberID)
        #expect(gameRepository.games.first?.status == .closed)
    }
    
    @Test
    func closingGameDoesNotBanUnselectedAbsentPlayer() async throws {
        // Same general setup as the previous test,
        // but pass:
        //
        // membersToBan: []
        //
        // Then assert:
        // #expect(banRepository.bans.isEmpty)
        // #expect(gameRepository.games.first?.status == .closed)
    }

    @Test
    func activeBanIsReturnedForCurrentlyBannedMember() async throws {
        let repository = MockMemberBanRepository()

        let memberID = UUID()
        let currentDate = Date()

        repository.bans = [
            MemberBan(
                id: UUID(),
                communityID: UUID(),
                memberID: memberID,
                sourceGameID: UUID(),
                startedAt: currentDate.addingTimeInterval(-60),
                endsAt: currentDate.addingTimeInterval(7 * 24 * 60 * 60),
                reason: .absence,
                createdByMemberID: UUID(),
                createdAt: currentDate.addingTimeInterval(-60)
            )
        ]

        let useCase = GetActiveBanUseCase(
            banRepository: repository
        )

        let result = try await useCase.execute(
            memberID: memberID,
            currentDate: currentDate
        )

        #expect(result != nil)
        #expect(result?.memberID == memberID)
    }
}
