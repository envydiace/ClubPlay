//
//  ChangeRegistrationStatusUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct ChangeRegistrationStatusUseCase {
    private let registrationRepository: WeeklyGameRegistrationRepository
    private let membershipRepository: CommunityMembershipRepository
    private let gameRepository: WeeklyFootballGameRepository

    init(
        registrationRepository: WeeklyGameRegistrationRepository,
        membershipRepository: CommunityMembershipRepository,
        gameRepository: WeeklyFootballGameRepository
    ) {
        self.registrationRepository = registrationRepository
        self.membershipRepository = membershipRepository
        self.gameRepository = gameRepository
    }

    func execute(
        registrationID: UUID,
        newStatus: RegistrationStatus,
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
                try await gameRepository.fetchGame(id: registration.gameID)
        else {
            throw GameManagementError.gameNotFound
        }

        guard let membership =
                try await membershipRepository.fetchMembership(
                    memberID: requestingMemberID,
                    communityID: game.communityID
                )
        else {
            throw GameManagementError.unauthorised
        }

        guard membership.role == .organiser else {
            throw GameManagementError.unauthorised
        }

        guard game.status != .cancelled else {
            throw RegistrationError.gameCancelled
        }

        guard game.status != .closed else {
            throw GameManagementError.gameAlreadyClosed
        }

        guard newStatus == .confirmed || newStatus == .waitlisted else {
            throw RegistrationError.invalidStatusChange
        }

        registration.registrationStatus = newStatus
        registration.updatedAt = currentDate

        try await registrationRepository.updateRegistration(registration)

        return registration
    }
}