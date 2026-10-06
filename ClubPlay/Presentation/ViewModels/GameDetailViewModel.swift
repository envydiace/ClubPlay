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
    private let cancelGameRegistrationUseCase: CancelGameRegistrationUseCase
    private let registrationRepository: WeeklyGameRegistrationRepository
    
    private let widgetSyncService: WidgetSyncing

    init(
        registerForGameUseCase: RegisterForGameUseCase,
        cancelGameRegistrationUseCase: CancelGameRegistrationUseCase,
        registrationRepository: WeeklyGameRegistrationRepository,
        widgetSyncService: WidgetSyncing
    ) {
        self.registerForGameUseCase = registerForGameUseCase
        self.cancelGameRegistrationUseCase =
            cancelGameRegistrationUseCase
        self.registrationRepository =
            registrationRepository
        self.widgetSyncService =
            widgetSyncService
    }
    
    func loadRegistration(
            memberID: UUID,
            gameID: UUID
        ) async {
            do {
                registration = try await registrationRepository.fetchRegistration(
                    memberID: memberID,
                    gameID: gameID
                )
            } catch {
                errorMessage = error.localizedDescription
            }
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

            await widgetSyncService.refreshNextGame(
                memberID: memberID
            )

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
    
    func cancel(
        memberID: UUID,
        gameID: UUID
    ) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        defer { isLoading = false }

        do {
            let result = try await cancelGameRegistrationUseCase.execute(
                memberID: memberID,
                gameID: gameID
            )

            registration = result

            await widgetSyncService.refreshNextGame(
                memberID: memberID
            )

            successMessage = "Registration cancelled."

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
