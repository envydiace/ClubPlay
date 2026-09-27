//
//  MarkAttendanceUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct MarkAttendanceUseCase {
    private let registrationRepository: WeeklyGameRegistrationRepository
    private let gameRepository: WeeklyFootballGameRepository
    private let membershipRepository: CommunityMembershipRepository

    init(
        registrationRepository: WeeklyGameRegistrationRepository,
        gameRepository: WeeklyFootballGameRepository,
        membershipRepository: CommunityMembershipRepository
    ) {
        self.registrationRepository = registrationRepository
        self.gameRepository = gameRepository
        self.membershipRepository = membershipRepository
    }

    func execute(
        registrationID: UUID,
        attendanceStatus: AttendanceStatus,
        requestingMemberID: UUID,
        currentDate: Date = Date()
    ) async throws -> WeeklyGameRegistration {

        guard var registration =
                try await registrationRepository.fetchRegistration(
                    id: registrationID
                )
        else {
            throw RegistrationError.registrationNotFound
        }

        guard let game =
                try await gameRepository.fetchGame(
                    id: registration.gameID
                )
        else {
            throw GameManagementError.gameNotFound
        }

        guard let membership =
                try await membershipRepository.fetchMembership(
                    memberID: requestingMemberID,
                    communityID: game.communityID
                ),
              membership.role == .organiser
        else {
            throw AttendanceError.unauthorised
        }

        guard game.status != .cancelled else {
            throw AttendanceError.gameCancelled
        }

        guard game.status != .closed else {
            throw GameManagementError.gameAlreadyClosed
        }

        guard registration.registrationStatus == .confirmed else {
            throw AttendanceError.registrationNotConfirmed
        }

        let attendanceOpenDate =
            Calendar.current.date(
                byAdding: .hour,
                value: -game.cancellationDeadlineHours,
                to: game.kickOffAt
            ) ?? game.kickOffAt

        guard currentDate >= attendanceOpenDate else {
            throw AttendanceError.attendanceNotOpen
        }

        registration.attendanceStatus = attendanceStatus
        registration.updatedAt = currentDate

        try await registrationRepository.updateRegistration(
            registration
        )

        return registration
    }
}