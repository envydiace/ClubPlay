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
        Group {
            if viewModel.isLoading && viewModel.players.isEmpty {
                loadingView

            } else if let errorMessage = viewModel.errorMessage,
                      viewModel.players.isEmpty {
                errorView(message: errorMessage)

            } else if viewModel.players.isEmpty {
                emptyView

            } else {
                playersList
            }
        }
        .navigationTitle("Players")
        .task {
            await viewModel.loadPlayers(gameID: gameID)
        }
        .refreshable {
            await viewModel.loadPlayers(gameID: gameID)
        }
    }

    private var playersList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.players) { item in
                    PlayerCardView(
                        item: item,
                        onPromote: {
                            Task {
                                await viewModel.changeStatus(
                                    registrationID:
                                        item.registration.id,
                                    newStatus: .confirmed,
                                    organiserID: organiserID,
                                    gameID: gameID
                                )
                            }
                        },
                        onWaitlist: {
                            Task {
                                await viewModel.changeStatus(
                                    registrationID:
                                        item.registration.id,
                                    newStatus: .waitlisted,
                                    organiserID: organiserID,
                                    gameID: gameID
                                )
                            }
                        },
                        onToggleAttendance: {
                            Task {
                                await viewModel.toggleAttendance(
                                    registration:
                                        item.registration,
                                    organiserID: organiserID,
                                    gameID: gameID
                                )
                            }
                        }
                    )
                }
            }
            .padding()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Loading players...")
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    private func errorView(
        message: String
    ) -> some View {
        ContentUnavailableView {
            Label(
                "Unable to Load Players",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                Task {
                    await viewModel.loadPlayers(
                        gameID: gameID
                    )
                }
            }
        }
    }

    private var emptyView: some View {
        ContentUnavailableView {
            Label(
                "No Players Yet",
                systemImage: "person.3"
            )
        } description: {
            Text(
                "Players who register for this game will appear here."
            )
        }
    }
}

private struct PlayerCardView: View {
    let item: GamePlayerItem

    let onPromote: () -> Void
    let onWaitlist: () -> Void
    let onToggleAttendance: () -> Void

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            HStack(alignment: .top) {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(item.member.fullName)
                        .font(.headline)

                    Text(item.member.emailAddress)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                registrationStatusBadge
            }

            if item.registration.registrationStatus == .confirmed {
                Divider()

                HStack {
                    Label(
                        "Attendance",
                        systemImage: "person.badge.clock"
                    )
                    .font(.subheadline)

                    Spacer()

                    Button {
                        onToggleAttendance()
                    } label: {
                        Label(
                            attendanceText,
                            systemImage: attendanceIcon
                        )
                    }
                    .buttonStyle(.bordered)
                    .tint(attendanceColor)
                }
            }

            Divider()

            HStack {
                switch item.registration.registrationStatus {
                case .waitlisted:
                    Button {
                        onPromote()
                    } label: {
                        Label(
                            "Promote",
                            systemImage: "arrow.up.circle"
                        )
                    }
                    .buttonStyle(.borderedProminent)

                case .confirmed:
                    Button {
                        onWaitlist()
                    } label: {
                        Label(
                            "Move to Waitlist",
                            systemImage: "arrow.down.circle"
                        )
                    }
                    .buttonStyle(.bordered)

                case .cancelled:
                    Text("Registration cancelled")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color(
                        uiColor:
                            .secondarySystemBackground
                    )
                )
        )
    }

    private var registrationStatusBadge: some View {
        Text(
            item.registration.registrationStatus
                .rawValue
                .capitalized
        )
        .font(.caption)
        .fontWeight(.semibold)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(
                    registrationStatusColor
                        .opacity(0.12)
                )
        )
        .foregroundStyle(registrationStatusColor)
    }

    private var registrationStatusColor: Color {
        switch item.registration.registrationStatus {
        case .confirmed:
            return .green

        case .waitlisted:
            return .orange

        case .cancelled:
            return .gray
        }
    }

    private var attendanceText: String {
        item.registration.attendanceStatus == .present
            ? "Present"
            : "Absent"
    }

    private var attendanceIcon: String {
        item.registration.attendanceStatus == .present
            ? "checkmark.circle.fill"
            : "xmark.circle"
    }

    private var attendanceColor: Color {
        item.registration.attendanceStatus == .present
            ? .green
            : .red
    }
}
