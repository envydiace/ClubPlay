//
//  WidgetSyncing.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import WidgetKit

@MainActor
protocol WidgetSyncing {
    func refreshNextGame(memberID: UUID) async
    func clear()
}

@MainActor
final class WidgetSyncService: WidgetSyncing {
    private let gameRepository: WeeklyFootballGameRepository
    private let registrationRepository: WeeklyGameRegistrationRepository

    init(
        gameRepository: WeeklyFootballGameRepository,
        registrationRepository: WeeklyGameRegistrationRepository
    ) {
        self.gameRepository = gameRepository
        self.registrationRepository = registrationRepository
    }

    func refreshNextGame(
        memberID: UUID
    ) async {
        do {
            let registrations =
                try await registrationRepository.fetchRegistrations(
                    forMemberID: memberID
                )

            let activeRegistrations = registrations.filter {
                $0.registrationStatus != .cancelled
            }

            var candidates: [
                (
                    registration: WeeklyGameRegistration,
                    game: WeeklyFootballGame
                )
            ] = []

            for registration in activeRegistrations {
                guard let game =
                        try await gameRepository.fetchGame(
                            id: registration.gameID
                        )
                else {
                    continue
                }

                guard game.kickOffAt > Date() else {
                    continue
                }

                guard game.status == .published else {
                    continue
                }

                candidates.append(
                    (
                        registration: registration,
                        game: game
                    )
                )
            }

            guard let next = candidates.min(
                by: {
                    $0.game.kickOffAt <
                    $1.game.kickOffAt
                }
            ) else {
                clear()
                return
            }

            let snapshot = NextGameWidgetSnapshot(
                gameName: next.game.gameName,
                venueName: next.game.venueName,
                kickOffAt: next.game.kickOffAt,
                registrationStatus:
                    next.registration.registrationStatus
                        .rawValue
                        .capitalized
            )

            WidgetSnapshotStore.save(snapshot)

            WidgetCenter.shared.reloadTimelines(
                ofKind: WidgetSharedConfig.widgetKind
            )

        } catch {
            print(
                "Failed to refresh widget snapshot:",
                error
            )
        }
    }

    func clear() {
        WidgetSnapshotStore.clear()

        WidgetCenter.shared.reloadTimelines(
            ofKind: WidgetSharedConfig.widgetKind
        )
    }
}