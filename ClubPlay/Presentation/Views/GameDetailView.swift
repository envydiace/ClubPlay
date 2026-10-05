//
//  GameDetailView.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import SwiftUI

struct GameDetailView: View {
    let game: WeeklyFootballGame
    let memberID: UUID

    @StateObject var viewModel: GameDetailViewModel

    var body: some View {
        Form {
            Section("Game") {
                Text(game.gameName)
                    .font(.headline)

                Text(game.venueName)

                LabeledContent(
                    "Kick-off",
                    value: game.kickOffAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )

                LabeledContent(
                    "Capacity",
                    value: "\(game.playerCapacity)"
                )
            }

            Section("Registration") {
                LabeledContent(
                    "Opens",
                    value: game.registrationOpensAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )

                LabeledContent(
                    "Closes",
                    value: game.registrationClosesAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )
            }

            if let registration = viewModel.registration {
                Section("Your Registration") {
                    Text(
                        registration.registrationStatus.rawValue.capitalized
                    )
                }
            }

            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundStyle(.green)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            
            if viewModel.registration == nil ||
               viewModel.registration?.registrationStatus == .cancelled {

                Button("Register for Game") {
                    Task {
                        await viewModel.register(
                            memberID: memberID,
                            gameID: game.id
                        )
                    }
                }
                .disabled(viewModel.isLoading)
            }
            
            if let registration = viewModel.registration,
               registration.registrationStatus != .cancelled {

                Button("Cancel Registration", role: .destructive) {
                    Task {
                        await viewModel.cancel(
                            memberID: memberID,
                            gameID: game.id
                        )
                    }
                }
            }
        }
        .navigationTitle("Game Details")
        .task {
            await viewModel.loadRegistration(
                memberID: memberID,
                gameID: game.id
            )
        }
    }
}
