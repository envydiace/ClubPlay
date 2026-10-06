//
//  UpcomingGamesView.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import SwiftUI

struct UpcomingGamesView: View {
    @StateObject var viewModel: UpcomingGamesViewModel
    private let dependencies = AppDependencies.shared

    let communityID: UUID
    let memberID: UUID

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            ForEach(viewModel.games) { game in
                NavigationLink {
                    let gameRepository =
                        dependencies.gameRepository

                    let registrationRepository =
                        dependencies.registrationRepository
                    
                    let promoteUseCase =
                        PromoteWaitlistedPlayerUseCase(
                            registrationRepository: registrationRepository
                        )

                    let cancelUseCase =
                        CancelGameRegistrationUseCase(
                            gameRepository: gameRepository,
                            registrationRepository: registrationRepository,
                            promoteWaitlistedPlayerUseCase: promoteUseCase
                        )

                    let registerUseCase =
                        RegisterForGameUseCase(
                            gameRepository: gameRepository,
                            registrationRepository: registrationRepository
                        )
                    
                    GameDetailView(
                        game: game,
                        memberID: memberID,
                        viewModel: GameDetailViewModel(
                            registerForGameUseCase: registerUseCase,
                            cancelGameRegistrationUseCase: cancelUseCase,
                            registrationRepository: registrationRepository
                        )
                    )
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(game.gameName)
                            .font(.headline)

                        Text(game.venueName)

                        Text(
                            game.kickOffAt.formatted(
                                date: .abbreviated,
                                time: .shortened
                            )
                        )
                        .foregroundStyle(.secondary)

                        Text("Capacity: \(game.playerCapacity)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Upcoming Games")
        .task {
            await viewModel.loadGames(
                communityID: communityID
            )
        }
    }
}
