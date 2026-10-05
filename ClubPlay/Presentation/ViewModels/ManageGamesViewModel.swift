//
//  ManageGamesViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Combine

@MainActor
final class ManageGamesViewModel: ObservableObject {
    @Published var games: [WeeklyFootballGame] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let gameRepository: WeeklyFootballGameRepository
    private let publishGameUseCase: PublishGameUseCase

    init(
        gameRepository: WeeklyFootballGameRepository,
        publishGameUseCase: PublishGameUseCase
    ) {
        self.gameRepository = gameRepository
        self.publishGameUseCase = publishGameUseCase
    }

    func loadGames(communityID: UUID) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            games = try await gameRepository.fetchGames(
                communityID: communityID
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func publishGame(
        gameID: UUID,
        organiserID: UUID,
        communityID: UUID
    ) async {
        do {
            try await publishGameUseCase.execute(
                gameID: gameID,
                requestingMemberID: organiserID
            )

            await loadGames(communityID: communityID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
