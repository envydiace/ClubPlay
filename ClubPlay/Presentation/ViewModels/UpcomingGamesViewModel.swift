//
//  UpcomingGamesViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//

import Foundation
import Combine

@MainActor
final class UpcomingGamesViewModel: ObservableObject {
    @Published var games: [WeeklyFootballGame] = []
    @Published var registrations: [WeeklyGameRegistration] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let gameRepository: WeeklyFootballGameRepository
    private let registrationRepository: WeeklyGameRegistrationRepository

    init(
        gameRepository: WeeklyFootballGameRepository,
        registrationRepository: WeeklyGameRegistrationRepository
    ) {
        self.gameRepository = gameRepository
        self.registrationRepository = registrationRepository
    }

    func loadGames(
        communityID: UUID,
        memberID: UUID
    ) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            async let gamesTask =
                gameRepository.fetchUpcomingGames(
                    communityID: communityID
                )

            async let registrationsTask =
                registrationRepository.fetchRegistrations(
                    forMemberID: memberID
                )

            games = try await gamesTask
            registrations = try await registrationsTask

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func registration(
        for gameID: UUID
    ) -> WeeklyGameRegistration? {
        registrations.first {
            $0.gameID == gameID
        }
    }

    func statusText(
        for game: WeeklyFootballGame
    ) -> String {
        if let registration = registration(for: game.id) {
            switch registration.registrationStatus {
            case .confirmed:
                return "Confirmed"

            case .waitlisted:
                return "Waitlisted"

            case .cancelled:
                break
            }
        }

        let now = Date()

        if now < game.registrationOpensAt {
            return "Opens Soon"
        }

        if now > game.registrationClosesAt {
            return "Registration Closed"
        }

        return "Registration Open"
    }
}
