//
//  GameDetailView.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//

import SwiftUI

struct GameDetailView: View {
    let game: WeeklyFootballGame
    let memberID: UUID

    @StateObject var viewModel: GameDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                gameHeader

                scheduleCard

                registrationCard

                if let successMessage = viewModel.successMessage {
                    messageView(
                        message: successMessage,
                        systemImage: "checkmark.circle.fill",
                        color: .green
                    )
                }

                if let errorMessage = viewModel.errorMessage {
                    messageView(
                        message: errorMessage,
                        systemImage: "exclamationmark.triangle.fill",
                        color: .red
                    )
                }

                actionSection
            }
            .padding()
        }
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadRegistration(
                memberID: memberID,
                gameID: game.id
            )
        }
    }

    // MARK: - Header

    private var gameHeader: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            HStack(alignment: .top) {
                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {
                    Text(game.gameName)
                        .font(.title2)
                        .fontWeight(.bold)

                    Label(
                        game.venueName,
                        systemImage: "mappin.and.ellipse"
                    )
                    .foregroundStyle(.secondary)
                }

                Spacer()

                registrationStatusBadge
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    // MARK: - Schedule

    private var scheduleCard: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Label("Game Schedule", systemImage: "calendar")
                .font(.headline)

            Divider()

            detailRow(
                title: "Date",
                value: game.kickOffAt.formatted(
                    date: .complete,
                    time: .omitted
                ),
                icon: "calendar"
            )

            detailRow(
                title: "Kick-off",
                value: game.kickOffAt.formatted(
                    date: .omitted,
                    time: .shortened
                ),
                icon: "clock"
            )

            detailRow(
                title: "Finishes",
                value: game.finishesAt.formatted(
                    date: .omitted,
                    time: .shortened
                ),
                icon: "flag.checkered"
            )

            detailRow(
                title: "Capacity",
                value: "\(game.playerCapacity) players",
                icon: "person.2"
            )
        }
        .cardStyle()
    }

    // MARK: - Registration

    private var registrationCard: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Label(
                "Registration",
                systemImage: "checkmark.circle"
            )
            .font(.headline)

            Divider()

            detailRow(
                title: "Opens",
                value: formatted(game.registrationOpensAt),
                icon: "lock.open"
            )

            detailRow(
                title: "Closes",
                value: formatted(game.registrationClosesAt),
                icon: "lock"
            )

            detailRow(
                title: "Cancellation deadline",
                value: formatted(cancellationDeadline),
                icon: "clock.badge.exclamationmark"
            )

            if let registration = viewModel.registration,
               registration.registrationStatus != .cancelled {

                Divider()

                HStack {
                    Text("Your status")
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text(
                        registration.registrationStatus
                            .rawValue
                            .capitalized
                    )
                    .fontWeight(.semibold)
                    .foregroundStyle(statusColor)
                }
            }
        }
        .cardStyle()
    }

    // MARK: - Actions

    @ViewBuilder
    private var actionSection: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)

        } else if canRegister {
            Button {
                Task {
                    await viewModel.register(
                        memberID: memberID,
                        gameID: game.id
                    )
                }
            } label: {
                Label(
                    "Register for Game",
                    systemImage: "checkmark.circle.fill"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

        } else if hasActiveRegistration {
            Button(role: .destructive) {
                Task {
                    await viewModel.cancel(
                        memberID: memberID,
                        gameID: game.id
                    )
                }
            } label: {
                Label(
                    "Cancel Registration",
                    systemImage: "xmark.circle"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

        } else if Date() < game.registrationOpensAt {
            unavailableMessage(
                "Registration has not opened yet."
            )

        } else if Date() > game.registrationClosesAt {
            unavailableMessage(
                "Registration for this game has closed."
            )
        }
    }

    // MARK: - State

    private var hasActiveRegistration: Bool {
        guard let registration = viewModel.registration else {
            return false
        }

        return registration.registrationStatus != .cancelled
    }

    private var canRegister: Bool {
        let now = Date()

        let noActiveRegistration =
            viewModel.registration == nil ||
            viewModel.registration?.registrationStatus == .cancelled

        return noActiveRegistration &&
            now >= game.registrationOpensAt &&
            now <= game.registrationClosesAt
    }

    private var cancellationDeadline: Date {
        game.kickOffAt.addingTimeInterval(
            -Double(game.cancellationDeadlineHours) * 3600
        )
    }

    // MARK: - Status

    private var statusText: String {
        if let registration = viewModel.registration {
            switch registration.registrationStatus {
            case .confirmed:
                return "Confirmed"

            case .waitlisted:
                return "Waitlisted"

            case .cancelled:
                break
            }
        }

        let now = Date()

        if now < game.registrationOpensAt {
            return "Opens Soon"
        }

        if now > game.registrationClosesAt {
            return "Closed"
        }

        return "Open"
    }

    private var statusColor: Color {
        switch statusText {
        case "Confirmed":
            return .green

        case "Waitlisted":
            return .orange

        case "Open":
            return .blue

        case "Opens Soon":
            return .purple

        default:
            return .gray
        }
    }

    private var registrationStatusBadge: some View {
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

    // MARK: - Helpers

    private func detailRow(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 22)
                .foregroundStyle(.secondary)

            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .multilineTextAlignment(.trailing)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }

    private func formatted(
        _ date: Date
    ) -> String {
        date.formatted(
            date: .abbreviated,
            time: .shortened
        )
    }

    private func messageView(
        message: String,
        systemImage: String,
        color: Color
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
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

    private func unavailableMessage(
        _ message: String
    ) -> some View {
        Text(message)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        Color(
                            uiColor:
                                .secondarySystemBackground
                        )
                    )
            )
    }
}

private extension View {
    func cardStyle() -> some View {
        self
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
}
