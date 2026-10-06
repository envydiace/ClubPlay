//
//  MyRegistrationsView.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import SwiftUI

struct MyRegistrationsView: View {
    @StateObject var viewModel: MyRegistrationsViewModel

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

            if viewModel.registrations.isEmpty && !viewModel.isLoading {
                Text("You have no registrations.")
                    .foregroundStyle(.secondary)
            }

            ForEach(viewModel.registrations) { registration in
                VStack(alignment: .leading, spacing: 6) {
                    Text(
                        registration.registrationStatus
                            .rawValue
                            .capitalized
                    )
                    .font(.headline)

                    Text(
                        "Game ID: \(registration.gameID.uuidString)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text(
                        registration.registeredAt.formatted(
                            date: .abbreviated,
                            time: .shortened
                        )
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("My Registrations")
        .task {
            await viewModel.loadRegistrations(
                memberID: memberID
            )
        }
    }
}