//
//  GamePlayersView.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import SwiftUI

struct GamePlayersView: View {
    @StateObject var viewModel: GamePlayersViewModel

    let gameID: UUID

    var body: some View {
        List(viewModel.players) { item in
            VStack(alignment: .leading) {
                Text(item.member.fullName)

                Text(
                    item.registration.registrationStatus
                        .rawValue
                        .capitalized
                )
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Players")
        .task {
            await viewModel.loadPlayers(
                gameID: gameID
            )
        }
    }
}