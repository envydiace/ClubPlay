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
    let dependencies: AppDependencyProviding
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.items.isEmpty {
                loadingView
            } else if let errorMessage = viewModel.errorMessage,
                      viewModel.items.isEmpty {
                errorView(message: errorMessage)
            } else if viewModel.items.isEmpty {
                emptyView
            } else {
                registrationsList
            }
        }
        .navigationTitle("My Games")
        .task {
            await viewModel.loadRegistrations(
                memberID: memberID
            )
        }
        .refreshable {
            await viewModel.loadRegistrations(
                memberID: memberID
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
                    registrationRepository
            )
        )
    }

    private var registrationsList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        gameDetailDestination(for: item.game)
                    } label: {
                        RegistrationCardView(item: item)
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

            Text("Loading your games...")
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
                "Unable to Load Registrations",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                Task {
                    await viewModel.loadRegistrations(
                        memberID: memberID
                    )
                }
            }
        }
    }

    private var emptyView: some View {
        ContentUnavailableView {
            Label(
                "No Registrations",
                systemImage: "checkmark.circle"
            )
        } description: {
            Text(
                "Games you register for will appear here."
            )
        }
    }
}

private struct RegistrationCardView: View {
    let item: MyRegistrationItem

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
                    Text(item.game.gameName)
                        .font(.headline)

                    Label(
                        item.game.venueName,
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
                        item.game.kickOffAt.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                } icon: {
                    Image(systemName: "calendar")
                }

                Label {
                    Text(
                        item.game.kickOffAt.formatted(
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
                Text("Registered")

                Spacer()

                Text(
                    item.registration.registeredAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    Color(
                        uiColor: .secondarySystemBackground
                    )
                )
        )
    }

    private var statusBadge: some View {
        Text(statusText)
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

    private var statusText: String {
        item.registration.registrationStatus
            .rawValue
            .capitalized
    }

    private var statusColor: Color {
        switch item.registration.registrationStatus {
        case .confirmed:
            return .green

        case .waitlisted:
            return .orange

        case .cancelled:
            return .gray
        }
    }
}

