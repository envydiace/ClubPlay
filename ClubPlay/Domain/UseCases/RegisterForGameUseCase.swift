//
//  RegisterForGameUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct RegisterForGameUseCase {
    private let gameRepository: WeeklyFootballGameRepository
    private let registrationRepository: WeeklyGameRegistrationRepository
    private let banRepository: MemberBanRepository

    init(
        gameRepository: WeeklyFootballGameRepository,
        registrationRepository: WeeklyGameRegistrationRepository,
        banRepository: MemberBanRepository
    ) {
        self.gameRepository = gameRepository
        self.registrationRepository = registrationRepository
        self.banRepository = banRepository
    }

    func execute(
        memberID: UUID,
        gameID: UUID,
        currentDate: Date = Date()
    ) async throws -> WeeklyGameRegistration {

        guard let game = try await gameRepository.fetchGame(id: gameID) else {
            throw GameManagementError.gameNotFound
        }

        guard game.status == .published else {
            if game.status == .cancelled {
                throw RegistrationError.gameCancelled
            }

            throw RegistrationError.registrationNotOpen
        }

        if let activeBan = try await banRepository.fetchActiveBan(
            forMemberID: memberID,
            at: currentDate
        ) {
            throw RegistrationError.memberBanned(until: activeBan.endsAt)
        }

        guard currentDate >= game.registrationOpensAt else {
            throw RegistrationError.registrationNotOpen
        }

        guard currentDate <= game.registrationClosesAt else {
            throw RegistrationError.registrationClosed
        }

        let existingRegistration =
            try await registrationRepository.fetchRegistration(
                memberID: memberID,
                gameID: gameID
            )

        if let existingRegistration,
           existingRegistration.registrationStatus != .cancelled {
            throw RegistrationError.duplicateRegistration
        }

        let registrations =
            try await registrationRepository.fetchRegistrations(
                forGameID: gameID
            )

        let confirmedCount = registrations.filter {
            $0.registrationStatus == .confirmed
        }.count

        let newStatus: RegistrationStatus =
            confirmedCount < game.playerCapacity
            ? .confirmed
            : .waitlisted

        if var existingRegistration {
            existingRegistration.registrationStatus = newStatus
            existingRegistration.attendanceStatus = .absent
            existingRegistration.updatedAt = currentDate

            try await registrationRepository.updateRegistration(
                existingRegistration
            )

            return existingRegistration
        }

        let registration = WeeklyGameRegistration(
            id: UUID(),
            memberID: memberID,
            gameID: gameID,
            registrationStatus: newStatus,
            attendanceStatus: .absent,
            registeredAt: currentDate,
            updatedAt: currentDate
        )

        try await registrationRepository.saveRegistration(registration)

        return registration
    }
}