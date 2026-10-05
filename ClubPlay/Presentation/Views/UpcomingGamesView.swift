//
//  UpcomingGamesView.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import SwiftUI

struct UpcomingGamesView: View {
    @StateObject var viewModel: UpcomingGamesViewModel

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
                    GameDetailView(
                        game: game,
                        memberID: memberID,
                        viewModel: GameDetailViewModel(
                            registerForGameUseCase: RegisterForGameUseCase(
                                gameRepository:
                                    SupabaseWeeklyFootballGameRepository(),

                                registrationRepository:
                                    SupabaseWeeklyGameRegistrationRepository(),

                            )
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
