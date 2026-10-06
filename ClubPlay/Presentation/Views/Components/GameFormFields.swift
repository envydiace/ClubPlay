//
//  GameFormFields.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import SwiftUI

struct GameFormFields: View {
    @Binding var gameName: String
    @Binding var venueName: String

    @Binding var kickOffAt: Date
    @Binding var finishesAt: Date

    @Binding var playerCapacity: Int

    @Binding var registrationOpensAt: Date
    @Binding var registrationClosesAt: Date

    @Binding var cancellationDeadlineHours: Int

    var body: some View {
        VStack(spacing: 18) {
            gameDetailsCard
            scheduleCard
            registrationCard
        }
    }

    private var gameDetailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Game Details", systemImage: "sportscourt")
                .font(.headline)

            Divider()

            TextField("Game name", text: $gameName)
                .textFieldStyle(.roundedBorder)

            TextField("Venue", text: $venueName)
                .textFieldStyle(.roundedBorder)

            HStack {
                Label("Capacity", systemImage: "person.2")

                Spacer()

                Stepper(
                    "\(playerCapacity)",
                    value: $playerCapacity,
                    in: 1...100
                )
                .fixedSize()
            }
        }
        .gameFormCard()
    }

    private var scheduleCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Schedule", systemImage: "calendar")
                .font(.headline)

            Divider()

            DatePicker(
                "Kick-off",
                selection: $kickOffAt
            )

            DatePicker(
                "Finish",
                selection: $finishesAt
            )
        }
        .gameFormCard()
    }

    private var registrationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(
                "Registration",
                systemImage: "checkmark.circle"
            )
            .font(.headline)

            Divider()

            DatePicker(
                "Opens",
                selection: $registrationOpensAt
            )

            DatePicker(
                "Closes",
                selection: $registrationClosesAt
            )

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(
                        "Cancellation deadline",
                        systemImage: "clock.badge.exclamationmark"
                    )

                    Spacer()

                    Stepper(
                        "\(cancellationDeadlineHours)h",
                        value: $cancellationDeadlineHours,
                        in: 0...24
                    )
                    .fixedSize()
                }

                Text(
                    "Players must cancel at least \(cancellationDeadlineHours) hour(s) before kick-off."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .gameFormCard()
    }
}

private extension View {
    func gameFormCard() -> some View {
        self
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
}