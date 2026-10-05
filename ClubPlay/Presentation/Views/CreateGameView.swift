//
//  CreateGameView.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import SwiftUI

struct CreateGameView: View {
    @StateObject var viewModel: CreateGameViewModel

    let communityID: UUID
    let organiserID: UUID

    var body: some View {
        Form {
            Section("Game") {
                TextField("Game name", text: $viewModel.gameName)
                TextField("Venue", text: $viewModel.venueName)

                Stepper(
                    "Capacity: \(viewModel.playerCapacity)",
                    value: $viewModel.playerCapacity,
                    in: 1...100
                )
            }

            Section("Schedule") {
                DatePicker(
                    "Kick-off",
                    selection: $viewModel.kickOffAt
                )

                DatePicker(
                    "Finish",
                    selection: $viewModel.finishesAt
                )
            }

            Section("Registration") {
                DatePicker(
                    "Registration opens",
                    selection: $viewModel.registrationOpensAt
                )

                DatePicker(
                    "Registration closes",
                    selection: $viewModel.registrationClosesAt
                )

                Stepper(
                    "Cancel at least \(viewModel.cancellationDeadlineHours) hour(s) before",
                    value: $viewModel.cancellationDeadlineHours,
                    in: 0...24
                )
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            if viewModel.didCreateGame {
                Text("Game created as draft.")
                    .foregroundStyle(.green)
            }

            Button("Create Draft Game") {
                Task {
                    await viewModel.createGame(
                        communityID: communityID,
                        organiserID: organiserID
                    )
                }
            }
            .disabled(viewModel.isLoading)
        }
        .navigationTitle("Create Game")
    }
}