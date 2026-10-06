//
//  ClubPlayWidget.swift
//  ClubPlayWidget
//
//  Created by Đức Anh on 7/10/26.
//

import WidgetKit
import SwiftUI

struct ClubPlayWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: NextGameWidgetSnapshot?
}

struct ClubPlayWidgetProvider: TimelineProvider {
    func placeholder(
        in context: Context
    ) -> ClubPlayWidgetEntry {
        ClubPlayWidgetEntry(
            date: Date(),
            snapshot: NextGameWidgetSnapshot(
                gameName: "Sunday Football",
                venueName: "Sydney Football Centre",
                kickOffAt: Date().addingTimeInterval(3600),
                registrationStatus: "Confirmed"
            )
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (ClubPlayWidgetEntry) -> Void
    ) {
        completion(
            ClubPlayWidgetEntry(
                date: Date(),
                snapshot: WidgetSnapshotStore.load()
            )
        )
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<ClubPlayWidgetEntry>) -> Void
    ) {
        let entry = ClubPlayWidgetEntry(
            date: Date(),
            snapshot: WidgetSnapshotStore.load()
        )

        let nextRefresh =
            Calendar.current.date(
                byAdding: .minute,
                value: 30,
                to: Date()
            ) ?? Date().addingTimeInterval(1800)

        completion(
            Timeline(
                entries: [entry],
                policy: .after(nextRefresh)
            )
        )
    }
}

struct ClubPlayWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    let entry: ClubPlayWidgetEntry

    var body: some View {
        Group {
            if let snapshot = entry.snapshot {
                switch family {
                case .systemSmall:
                    smallView(snapshot)

                case .systemMedium:
                    mediumView(snapshot)

                default:
                    mediumView(snapshot)
                }
            } else {
                emptyView
            }
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
        .widgetURL(
            URL(string: "clubplay://games")
        )
    }

    private func smallView(
        _ snapshot: NextGameWidgetSnapshot
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Image(systemName: "sportscourt")
                .font(.title3)
                .foregroundStyle(.secondary)

            Spacer(minLength: 0)

            Text(snapshot.gameName)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            Text(
                compactDateTime(
                    snapshot.kickOffAt
                )
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .lineLimit(1)

            Text(snapshot.registrationStatus)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(
                    statusColor(
                        snapshot.registrationStatus
                    )
                )
                .lineLimit(1)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading
        )
        .padding()
    }

    private func mediumView(
        _ snapshot: NextGameWidgetSnapshot
    ) -> some View {
        HStack(spacing: 16) {
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                Label(
                    "Next Game",
                    systemImage: "sportscourt"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Text(snapshot.gameName)
                    .font(.headline)
                    .lineLimit(2)

                Label(
                    snapshot.venueName,
                    systemImage: "mappin.and.ellipse"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }

            Spacer()

            VStack(
                alignment: .trailing,
                spacing: 8
            ) {
                Text(
                    snapshot.kickOffAt.formatted(
                        date: .abbreviated,
                        time: .omitted
                    )
                )
                .font(.caption)

                Text(
                    snapshot.kickOffAt.formatted(
                        date: .omitted,
                        time: .shortened
                    )
                )
                .font(.title3)
                .fontWeight(.semibold)

                Text(snapshot.registrationStatus)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        statusColor(
                            snapshot.registrationStatus
                        )
                    )
            }
        }
        .padding()
    }

    @ViewBuilder
    private var emptyView: some View {
        switch family {
        case .systemSmall:
            VStack(spacing: 10) {
                Image(systemName: "sportscourt")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Text("No Upcoming Game")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text("Open ClubPlay")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .padding()

        default:
            VStack(spacing: 8) {
                Image(systemName: "sportscourt")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Text("No Upcoming Game")
                    .font(.headline)

                Text(
                    "Register for a game in ClubPlay."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .padding()
        }
    }

    private func compactDateTime(
        _ date: Date
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM • h:mm a"
        return formatter.string(from: date)
    }

    private func statusColor(
        _ status: String
    ) -> Color {
        switch status.lowercased() {
        case "confirmed":
            return .green

        case "waitlisted":
            return .orange

        default:
            return .secondary
        }
    }
}

struct ClubPlayWidget: Widget {
    let kind = WidgetSharedConfig.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: ClubPlayWidgetProvider()
        ) { entry in
            ClubPlayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Next ClubPlay Game")
        .description(
            "Shows your next registered ClubPlay game."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

#Preview(
    "Small",
    as: .systemSmall
) {
    ClubPlayWidget()
} timeline: {
    ClubPlayWidgetEntry(
        date: Date(),
        snapshot: NextGameWidgetSnapshot(
            gameName: "Wednesday Night Football",
            venueName: "Sydney Football Centre",
            kickOffAt: Date().addingTimeInterval(3600),
            registrationStatus: "Confirmed"
        )
    )
}

#Preview(
    "Medium",
    as: .systemMedium
) {
    ClubPlayWidget()
} timeline: {
    ClubPlayWidgetEntry(
        date: Date(),
        snapshot: NextGameWidgetSnapshot(
            gameName: "Wednesday Night Game",
            venueName: "UTS Sports Field",
            kickOffAt: Date().addingTimeInterval(7200),
            registrationStatus: "Waitlisted"
        )
    )
}

#Preview(
    "No Upcoming Game",
    as: .systemSmall
) {
    ClubPlayWidget()
} timeline: {
    ClubPlayWidgetEntry(
        date: Date(),
        snapshot: nil
    )
}
