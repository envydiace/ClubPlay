//
//  ManageGamesView.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import SwiftUI

struct ManageGamesView: View {
    @StateObject var viewModel: ManageGamesViewModel

    let communityID: UUID
    let organiserID: UUID

    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            ForEach(viewModel.games) { game in
                VStack(alignment: .leading, spacing: 8) {
                    Text(game.gameName)
                        .font(.headline)

                    Text(game.venueName)

                    Text(game.status.rawValue.capitalized)
                        .foregroundStyle(.secondary)

                    if game.status == .draft {
                        Button("Publish") {
                            Task {
                                await viewModel.publishGame(
                                    gameID: game.id,
                                    organiserID: organiserID,
                                    communityID: communityID
                                )
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Manage Games")
        .task {
            await viewModel.loadGames(
                communityID: communityID
            )
        }
    }
}