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
        ScrollView {
            VStack(spacing: 20) {
                GameFormFields(
                    gameName: $viewModel.gameName,
                    venueName: $viewModel.venueName,
                    kickOffAt: $viewModel.kickOffAt,
                    finishesAt: $viewModel.finishesAt,
                    playerCapacity: $viewModel.playerCapacity,
                    registrationOpensAt:
                        $viewModel.registrationOpensAt,
                    registrationClosesAt:
                        $viewModel.registrationClosesAt,
                    cancellationDeadlineHours:
                        $viewModel.cancellationDeadlineHours
                )

                if let errorMessage = viewModel.errorMessage {
                    messageView(
                        errorMessage,
                        color: .red,
                        icon: "exclamationmark.triangle.fill"
                    )
                }

                if viewModel.didSave {
                    messageView(
                        "Game updated.",
                        color: .green,
                        icon: "checkmark.circle.fill"
                    )
                }

                Button {
                    Task {
                        await viewModel.save(
                            organiserID: organiserID
                        )
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Label(
                            "Save Changes",
                            systemImage: "checkmark.circle.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(viewModel.isLoading)
            }
            .padding()
        }
        .navigationTitle("Edit Game")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func messageView(
        _ message: String,
        color: Color,
        icon: String
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)

            Text(message)
                .font(.subheadline)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.08))
        )
    }
}
