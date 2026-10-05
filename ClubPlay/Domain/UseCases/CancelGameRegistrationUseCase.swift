//
//  CancelGameRegistrationUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct CancelGameRegistrationUseCase {
    private let gameRepository: WeeklyFootballGameRepository
    private let registrationRepository: WeeklyGameRegistrationRepository
    private let promoteWaitlistedPlayerUseCase: PromoteWaitlistedPlayerUseCase

    init(
        gameRepository: WeeklyFootballGameRepository,
        registrationRepository: WeeklyGameRegistrationRepository,
        promoteWaitlistedPlayerUseCase: PromoteWaitlistedPlayerUseCase
    ) {
        self.gameRepository = gameRepository
        self.registrationRepository = registrationRepository
        self.promoteWaitlistedPlayerUseCase = promoteWaitlistedPlayerUseCase
    }

    func execute(
        memberID: UUID,
        gameID: UUID,
        currentDate: Date = Date()
    ) async throws -> WeeklyGameRegistration {

        guard let game = try await gameRepository.fetchGame(id: gameID) else {
            throw GameManagementError.gameNotFound
        }

        guard game.status != .cancelled else {
            throw RegistrationError.gameCancelled
        }

        guard let registration =
            try await registrationRepository.fetchRegistration(
                memberID: memberID,
                gameID: gameID
            )
        else {
            throw RegistrationError.registrationNotFound
        }

        guard registration.registrationStatus != .cancelled else {
            throw RegistrationError.registrationNotFound
        }

        let cancellationDeadline =
            Calendar.current.date(
                byAdding: .hour,
                value: -game.cancellationDeadlineHours,
                to: game.kickOffAt
            ) ?? game.kickOffAt

        guard currentDate <= cancellationDeadline else {
            throw RegistrationError.cancellationDeadlinePassed
        }

        let previousStatus = registration.registrationStatus

        var updatedRegistration = registration
        updatedRegistration.registrationStatus = .cancelled
        updatedRegistration.updatedAt = currentDate

        try await registrationRepository.updateRegistration(
            updatedRegistration
        )

        if previousStatus == .confirmed {
            _ = try? await promoteWaitlistedPlayerUseCase.execute(
                gameID: gameID
            )
        }

        return updatedRegistration
    }
}
