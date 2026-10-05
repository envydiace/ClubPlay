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
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let gameRepository: WeeklyFootballGameRepository

    init(gameRepository: WeeklyFootballGameRepository) {
        self.gameRepository = gameRepository
    }

    func loadGames(communityID: UUID) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            games = try await gameRepository.fetchUpcomingGames(
                communityID: communityID
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
