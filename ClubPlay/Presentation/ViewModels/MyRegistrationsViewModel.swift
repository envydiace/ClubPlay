//
//  MyRegistrationsViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//

import Foundation
import Combine

@MainActor
final class MyRegistrationsViewModel: ObservableObject {
    @Published var items: [MyRegistrationItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let registrationRepository:
        WeeklyGameRegistrationRepository

    private let gameRepository:
        WeeklyFootballGameRepository

    init(
        registrationRepository: WeeklyGameRegistrationRepository,
        gameRepository: WeeklyFootballGameRepository
    ) {
        self.registrationRepository = registrationRepository
        self.gameRepository = gameRepository
    }

    func loadRegistrations(
        memberID: UUID
    ) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let registrations =
                try await registrationRepository.fetchRegistrations(
                    forMemberID: memberID
                )

            var loadedItems: [MyRegistrationItem] = []

            for registration in registrations {
                if let game = try await gameRepository.fetchGame(
                    id: registration.gameID
                ) {
                    loadedItems.append(
                        MyRegistrationItem(
                            registration: registration,
                            game: game
                        )
                    )
                }
            }

            items = loadedItems.sorted {
                $0.game.kickOffAt < $1.game.kickOffAt
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
