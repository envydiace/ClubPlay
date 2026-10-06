//
//  WidgetSnapshotStore.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation

enum WidgetSnapshotStore {

    static func save(
        _ snapshot: NextGameWidgetSnapshot
    ) {
        guard let defaults = UserDefaults(
            suiteName: WidgetSharedConfig.appGroupIdentifier
        ) else {
            return
        }

        do {
            let data = try JSONEncoder().encode(snapshot)

            defaults.set(
                data,
                forKey: WidgetSharedConfig.nextGameSnapshotKey
            )
        } catch {
            print(
                "Failed to save widget snapshot:",
                error
            )
        }
    }

    static func load() -> NextGameWidgetSnapshot? {
        guard
            let defaults = UserDefaults(
                suiteName:
                    WidgetSharedConfig.appGroupIdentifier
            ),
            let data = defaults.data(
                forKey:
                    WidgetSharedConfig.nextGameSnapshotKey
            )
        else {
            return nil
        }

        return try? JSONDecoder().decode(
            NextGameWidgetSnapshot.self,
            from: data
        )
    }

    static func clear() {
        let defaults = UserDefaults(
            suiteName: WidgetSharedConfig.appGroupIdentifier
        )

        defaults?.removeObject(
            forKey: WidgetSharedConfig.nextGameSnapshotKey
        )
    }
}