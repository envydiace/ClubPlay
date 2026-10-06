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

    let dependencies: AppDependencyProviding

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.games.isEmpty {
                loadingView
            } else if let errorMessage = viewModel.errorMessage,
                      viewModel.games.isEmpty {
                errorView(message: errorMessage)
            } else if viewModel.games.isEmpty {
                emptyView
            } else {
                gamesList
            }
        }
        .navigationTitle("Manage Games")
        .task {
            await viewModel.loadGames(
                communityID: communityID
            )
        }
        .refreshable {
            await viewModel.loadGames(
                communityID: communityID
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    createGameDestination
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    // MARK: - List

    private var gamesList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.games) { game in
                    ManageGameCard(
                        game: game,
                        onPublish: {
                            Task {
                                await viewModel.publishGame(
                                    gameID: game.id,
                                    organiserID: organiserID,
                                    communityID: communityID
                                )
                            }
                        },
                        editDestination: {
                            editGameDestination(for: game)
                        },
                        playersDestination: {
                            playersDestination(for: game)
                        }
                    )
                }
            }
            .padding()
        }
    }

    // MARK: - Create

    private var createGameDestination: some View {
        CreateGameView(
            viewModel: CreateGameViewModel(
                createGameUseCase: CreateGameUseCase(
                    gameRepository:
                        dependencies.gameRepository,
                    membershipRepository:
                        dependencies.membershipRepository
                )
            ),
            communityID: communityID,
            organiserID: organiserID
        )
    }

    // MARK: - Edit

    @ViewBuilder
    private func editGameDestination(
        for game: WeeklyFootballGame
    ) -> some View {
        EditGameView(
            viewModel: EditGameViewModel(
                game: game,
                editGameUseCase: EditGameUseCase(
                    gameRepository:
                        dependencies.gameRepository,
                    membershipRepository:
                        dependencies.membershipRepository,
                    registrationRepository:
                        dependencies.registrationRepository,
                    notificationRepository:
                        NoOpNotificationRepository()
                )
            ),
            organiserID: organiserID
        )
    }

    // MARK: - Players

    @ViewBuilder
    private func playersDestination(
        for game: WeeklyFootballGame
    ) -> some View {
        let registrationRepository =
            dependencies.registrationRepository

        let membershipRepository =
            dependencies.membershipRepository

        let gameRepository =
            dependencies.gameRepository

        GamePlayersView(
            viewModel: GamePlayersViewModel(
                registrationRepository:
                    registrationRepository,
                memberRepository:
                    dependencies.memberRepository,
                changeRegistrationStatusUseCase:
                    ChangeRegistrationStatusUseCase(
                        registrationRepository:
                            registrationRepository,
                        membershipRepository:
                            membershipRepository,
                        gameRepository:
                            gameRepository
                    ),
                markAttendanceUseCase:
                    MarkAttendanceUseCase(
                        registrationRepository:
                            registrationRepository,
                        gameRepository:
                            gameRepository,
                        membershipRepository:
                            membershipRepository
                    )
            ),
            gameID: game.id,
            organiserID: organiserID
        )
    }

    // MARK: - States

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Loading games...")
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
                "Unable to Load Games",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                Task {
                    await viewModel.loadGames(
                        communityID: communityID
                    )
                }
            }
        }
    }

    private var emptyView: some View {
        ContentUnavailableView {
            Label(
                "No Games Yet",
                systemImage: "sportscourt"
            )
        } description: {
            Text(
                "Create your first game using the + button."
            )
        }
    }
}

private struct ManageGameCard<
    EditDestination: View,
    PlayersDestination: View
>: View {

    let game: WeeklyFootballGame
    let onPublish: () -> Void

    @ViewBuilder
    let editDestination: () -> EditDestination

    @ViewBuilder
    let playersDestination: () -> PlayersDestination

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            HStack(alignment: .top) {
                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {
                    Text(game.gameName)
                        .font(.headline)

                    Label(
                        game.venueName,
                        systemImage: "mappin.and.ellipse"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                statusBadge
            }

            Divider()

            HStack(spacing: 20) {
                Label {
                    Text(
                        game.kickOffAt.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                } icon: {
                    Image(systemName: "calendar")
                }

                Label {
                    Text(
                        game.kickOffAt.formatted(
                            date: .omitted,
                            time: .shortened
                        )
                    )
                } icon: {
                    Image(systemName: "clock")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HStack {
                Label(
                    "\(game.playerCapacity) players",
                    systemImage: "person.2"
                )

                Spacer()
            }
            .font(.subheadline)

            Divider()

            HStack(spacing: 10) {
                if game.status == .draft ||
                    game.status == .published {

                    NavigationLink {
                        editDestination()
                    } label: {
                        Label(
                            "Edit",
                            systemImage: "pencil"
                        )
                    }
                    .buttonStyle(.bordered)
                }

                NavigationLink {
                    playersDestination()
                } label: {
                    Label(
                        "Players",
                        systemImage: "person.3"
                    )
                }
                .buttonStyle(.bordered)

                Spacer()

                if game.status == .draft {
                    Button {
                        onPublish()
                    } label: {
                        Label(
                            "Publish",
                            systemImage: "paperplane"
                        )
                    }
                    .buttonStyle(.borderedProminent)
                }
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

    private var statusBadge: some View {
        Text(game.status.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(statusColor.opacity(0.12))
            )
            .foregroundStyle(statusColor)
    }

    private var statusColor: Color {
        switch game.status {
        case .draft:
            return .orange

        case .published:
            return .green

        case .closed:
            return .gray

        case .cancelled:
            return .red
        }
    }
}
