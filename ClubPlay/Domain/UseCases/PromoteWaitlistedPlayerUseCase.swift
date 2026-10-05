//
//  PromoteWaitlistedPlayerUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct PromoteWaitlistedPlayerUseCase {
    private let registrationRepository: WeeklyGameRegistrationRepository

    init(
        registrationRepository: WeeklyGameRegistrationRepository
    ) {
        self.registrationRepository = registrationRepository
    }

    func execute(
        gameID: UUID
    ) async throws -> UUID? {
        try await registrationRepository.promoteNextWaitlistedPlayer(
            gameID: gameID
        )
    }
}
