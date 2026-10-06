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
    let organiserID: UUID

    var body: some View {
        List {
            ForEach(viewModel.players) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.member.fullName)

                    Text(
                        item.registration.registrationStatus
                            .rawValue
                            .capitalized
                    )
                    .foregroundStyle(.secondary)

                    if item.registration.registrationStatus == .waitlisted {
                        Button("Promote to Confirmed") {
                            Task {
                                await viewModel.changeStatus(
                                    registrationID: item.registration.id,
                                    newStatus: .confirmed,
                                    organiserID: organiserID,
                                    gameID: gameID
                                )
                            }
                        }
                    }

                    if item.registration.registrationStatus == .confirmed {
                        Button("Move to Waitlist") {
                            Task {
                                await viewModel.changeStatus(
                                    registrationID: item.registration.id,
                                    newStatus: .waitlisted,
                                    organiserID: organiserID,
                                    gameID: gameID
                                )
                            }
                        }
                    }
                    
                    if item.registration.registrationStatus == .confirmed {
                        Button {
                            Task {
                                await viewModel.toggleAttendance(
                                    registration: item.registration,
                                    organiserID: organiserID,
                                    gameID: gameID
                                )
                            }
                        } label: {
                            Label(
                                item.registration.attendanceStatus == .present
                                    ? "Present"
                                    : "Absent",
                                systemImage:
                                    item.registration.attendanceStatus == .present
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("Players")
        .task {
            await viewModel.loadPlayers(gameID: gameID)
        }
    }
}
