//
//  GameDetailViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation
import Combine

@MainActor
final class GameDetailViewModel: ObservableObject {
    @Published var registration: WeeklyGameRegistration?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let registerForGameUseCase: RegisterForGameUseCase

    init(
        registerForGameUseCase: RegisterForGameUseCase
    ) {
        self.registerForGameUseCase = registerForGameUseCase
    }

    func register(
        memberID: UUID,
        gameID: UUID
    ) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        defer { isLoading = false }

        do {
            let result = try await registerForGameUseCase.execute(
                memberID: memberID,
                gameID: gameID
            )

            registration = result

            switch result.registrationStatus {
            case .confirmed:
                successMessage = "Registration confirmed."

            case .waitlisted:
                successMessage = "The game is full. You have been added to the waitlist."

            case .cancelled:
                successMessage = nil
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
