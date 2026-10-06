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
    }

    private func smallView(
        _ snapshot: NextGameWidgetSnapshot
    ) -> some View {
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

            Spacer()

            Text(snapshot.gameName)
                .font(.headline)
                .lineLimit(2)

            Text(
                snapshot.kickOffAt.formatted(
                    date: .abbreviated,
                    time: .shortened
                )
            )
            .font(.caption)

            Text(snapshot.registrationStatus)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundStyle(.green)
        }
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

                Label(
                    snapshot.venueName,
                    systemImage: "mappin.and.ellipse"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
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
                    .foregroundStyle(.green)
            }
        }
        .padding()
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "sportscourt")
                .font(.title2)

            Text("No Upcoming Game")
                .font(.headline)

            Text("Register for a game in ClubPlay.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
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
            gameName: "Sunday Football",
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

