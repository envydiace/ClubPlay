//
//  EditGameViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation
import Combine

@MainActor
final class EditGameViewModel: ObservableObject {
    @Published var gameName: String
    @Published var venueName: String
    @Published var kickOffAt: Date
    @Published var finishesAt: Date
    @Published var playerCapacity: Int
    @Published var registrationOpensAt: Date
    @Published var registrationClosesAt: Date
    @Published var cancellationDeadlineHours: Int

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSave = false

    private var game: WeeklyFootballGame
    private let editGameUseCase: EditGameUseCase

    init(
        game: WeeklyFootballGame,
        editGameUseCase: EditGameUseCase
    ) {
        self.game = game
        self.editGameUseCase = editGameUseCase

        self.gameName = game.gameName
        self.venueName = game.venueName
        self.kickOffAt = game.kickOffAt
        self.finishesAt = game.finishesAt
        self.playerCapacity = game.playerCapacity
        self.registrationOpensAt = game.registrationOpensAt
        self.registrationClosesAt = game.registrationClosesAt
        self.cancellationDeadlineHours = game.cancellationDeadlineHours
    }

    func save(
        organiserID: UUID
    ) async {
        isLoading = true
        errorMessage = nil
        didSave = false

        defer { isLoading = false }

        game.gameName = gameName
        game.venueName = venueName
        game.kickOffAt = kickOffAt
        game.finishesAt = finishesAt
        game.playerCapacity = playerCapacity
        game.registrationOpensAt = registrationOpensAt
        game.registrationClosesAt = registrationClosesAt
        game.cancellationDeadlineHours = cancellationDeadlineHours

        do {
            try await editGameUseCase.execute(
                game: game,
                requestingMemberID: organiserID
            )

            didSave = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
