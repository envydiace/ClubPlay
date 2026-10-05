//
//  CreateGameViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Combine

@MainActor
final class CreateGameViewModel: ObservableObject {
    @Published var gameName = ""
    @Published var venueName = ""

    @Published var kickOffAt = Date().addingTimeInterval(24 * 60 * 60)
    @Published var finishesAt = Date().addingTimeInterval(26 * 60 * 60)

    @Published var playerCapacity = 16
    
    @Published var registrationOpensAt = Date()
    @Published var registrationClosesAt = Date().addingTimeInterval(22 * 60 * 60)

    @Published var cancellationDeadlineHours = 2

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didCreateGame = false

    private let createGameUseCase: CreateGameUseCase

    init(createGameUseCase: CreateGameUseCase) {
        self.createGameUseCase = createGameUseCase
    }

    func createGame(
        communityID: UUID,
        organiserID: UUID
    ) async {
        isLoading = true
        errorMessage = nil
        didCreateGame = false

        defer { isLoading = false }

        let game = WeeklyFootballGame(
            id: UUID(),
            communityID: communityID,
            gameName: gameName,
            venueName: venueName,
            kickOffAt: kickOffAt,
            finishesAt: finishesAt,
            playerCapacity: playerCapacity,
            registrationOpensAt: registrationOpensAt,
            registrationClosesAt: registrationClosesAt,
            cancellationDeadlineHours: cancellationDeadlineHours,
            status: .draft,
            createdAt: Date(),
            createdByMemberID: organiserID
        )

        do {
            try await createGameUseCase.execute(
                game: game,
                requestingMemberID: organiserID
            )

            didCreateGame = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
