//
//  PromoteWaitlistedPlayerUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct PromoteWaitlistedPlayerUseCase {
    private let gameRepository: WeeklyFootballGameRepository
    private let registrationRepository: WeeklyGameRegistrationRepository

    init(
        gameRepository: WeeklyFootballGameRepository,
        registrationRepository: WeeklyGameRegistrationRepository
    ) {
        self.gameRepository = gameRepository
        self.registrationRepository = registrationRepository
    }

    func execute(
        gameID: UUID,
        currentDate: Date = Date()
    ) async throws -> WeeklyGameRegistration {

        guard let game = try await gameRepository.fetchGame(id: gameID) else {
            throw GameManagementError.gameNotFound
        }

        let registrations =
            try await registrationRepository.fetchRegistrations(
                forGameID: gameID
            )

        let confirmedCount = registrations.filter {
            $0.registrationStatus == .confirmed
        }.count

        guard confirmedCount < game.playerCapacity else {
            throw RegistrationError.noWaitlistedPlayer
        }

        guard let firstWaitlisted = registrations
            .filter({
                $0.registrationStatus == .waitlisted
            })
            .sorted(by: {
                $0.registeredAt < $1.registeredAt
            })
            .first
        else {
            throw RegistrationError.noWaitlistedPlayer
        }

        var promoted = firstWaitlisted
        promoted.registrationStatus = .confirmed
        promoted.updatedAt = currentDate

        try await registrationRepository.updateRegistration(promoted)

        return promoted
    }
}