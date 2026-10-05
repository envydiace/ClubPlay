//
//  EditGameView.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import SwiftUI

struct EditGameView: View {
    @StateObject var viewModel: EditGameViewModel

    let organiserID: UUID

    var body: some View {
        Form {
            Section("Game") {
                TextField(
                    "Game name",
                    text: $viewModel.gameName
                )

                TextField(
                    "Venue",
                    text: $viewModel.venueName
                )

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

            if viewModel.didSave {
                Text("Game updated.")
                    .foregroundStyle(.green)
            }

            Button("Save Changes") {
                Task {
                    await viewModel.save(
                        organiserID: organiserID
                    )
                }
            }
            .disabled(viewModel.isLoading)
        }
        .navigationTitle("Edit Game")
    }
}