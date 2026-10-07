//
//  PromoteWaitlistedPlayerUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("PromoteWaitlistedPlayerUseCase")
struct PromoteWaitlistedPlayerUseCaseTests {

    @Test("Promotes the next waitlisted player for the selected game")
    func promotesNextWaitlistedPlayer() async throws {
        let gameID = UUID()
        let waitlistedMemberID = UUID()

        let registrationRepository =
            MockWeeklyGameRegistrationRepository()

        registrationRepository.promotedMemberID =
            waitlistedMemberID

        let useCase =
            PromoteWaitlistedPlayerUseCase(
                registrationRepository:
                    registrationRepository
            )

        let result = try await useCase.execute(
            gameID: gameID
        )

        #expect(result == waitlistedMemberID)

        #expect(
            registrationRepository.promotedGameID
                == gameID
        )
        
        #expect(
            registrationRepository
                .promoteNextWaitlistedPlayerCalled
        )
    }
}
