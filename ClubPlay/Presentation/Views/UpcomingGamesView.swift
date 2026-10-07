//
//  UpcomingGamesView.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//

import SwiftUI

struct UpcomingGamesView: View {
    @StateObject var viewModel: UpcomingGamesViewModel
    @State private var notificationGame: WeeklyFootballGame?

    let openedGame: WeeklyFootballGame?
    let communityID: UUID
    let memberID: UUID

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
        .navigationTitle("Upcoming Games")
        .task {
            await viewModel.loadGames(
                communityID: communityID,
                memberID: memberID
            )
        }
        .refreshable {
            await viewModel.loadGames(
                communityID: communityID,
                memberID: memberID
            )
        }
        .onChange(of: openedGame?.id) { _, _ in
            notificationGame = openedGame
        }
        .navigationDestination(
            isPresented: Binding(
                get: {
                    notificationGame != nil
                },
                set: { isPresented in
                    if !isPresented {
                        notificationGame = nil
                    }
                }
            )
        ) {
            if let game = notificationGame {
                gameDetailDestination(for: game)
            }
        }
    }

    private var gamesList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.games) { game in
                    NavigationLink {
                        gameDetailDestination(for: game)
                    } label: {
                        GameCardView(
                            game: game,
                            status: viewModel.statusText(for: game)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Loading upcoming games...")
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
                        communityID: communityID,
                        memberID: memberID
                    )
                }
            }
        }
    }

    private var emptyView: some View {
        ContentUnavailableView {
            Label(
                "No Upcoming Games",
                systemImage: "sportscourt"
            )
        } description: {
            Text(
                "There are no published games available yet."
            )
        }
    }

    @ViewBuilder
    private func gameDetailDestination(
        for game: WeeklyFootballGame
    ) -> some View {
        let gameRepository =
            dependencies.gameRepository

        let registrationRepository =
            dependencies.registrationRepository

        let promoteUseCase =
            PromoteWaitlistedPlayerUseCase(
                registrationRepository:
                    registrationRepository
            )

        let cancelUseCase =
            CancelGameRegistrationUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository,
                promoteWaitlistedPlayerUseCase:
                    promoteUseCase
            )

        let registerUseCase =
            RegisterForGameUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository
            )

        GameDetailView(
            game: game,
            memberID: memberID,
            viewModel: GameDetailViewModel(
                registerForGameUseCase:
                    registerUseCase,
                cancelGameRegistrationUseCase:
                    cancelUseCase,
                registrationRepository:
                    registrationRepository,
                widgetSyncService:
                    dependencies.widgetSyncService
            )
        )
    }
}

private struct GameCardView: View {
    let game: WeeklyFootballGame
    let status: String

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 14
        ) {
            HStack(
                alignment: .top,
                spacing: 12
            ) {
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    Text(game.gameName)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Label(
                        game.venueName,
                        systemImage: "mappin.and.ellipse"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Image(
                    systemName: "chevron.right"
                )
                .font(.caption)
                .foregroundStyle(.tertiary)
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
                    Image(
                        systemName: "calendar"
                    )
                }

                Label {
                    Text(
                        game.kickOffAt.formatted(
                            date: .omitted,
                            time: .shortened
                        )
                    )
                } icon: {
                    Image(
                        systemName: "clock"
                    )
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

                Text(status)
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
            .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color(
                    uiColor: .secondarySystemBackground
                )
            )
        )
    }
    
    private var statusColor: Color {
        switch status {
        case "Confirmed":
            return .green

        case "Waitlisted":
            return .orange

        case "Registration Open":
            return .blue

        case "Opens Soon":
            return .purple

        case "Registration Closed":
            return .gray

        default:
            return .secondary
        }
    }
}
