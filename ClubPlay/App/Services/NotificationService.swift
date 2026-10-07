//
//  NotificationService.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import UserNotifications

enum NotificationCategory {
    static let gameUpdate = "CLUBPLAY_GAME_UPDATE"
}

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func configure() {
        let category = UNNotificationCategory(
            identifier: NotificationCategory.gameUpdate,
            actions: [],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current()
            .setNotificationCategories([category])
    }
    
    func scheduleTestNotification() async throws {
        let granted = try await requestAuthorization()

        guard granted else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Game Updated"
        content.body = "Sunday Football has a new kick-off time."
        content.sound = .default
        content.categoryIdentifier = NotificationCategory.gameUpdate

        content.userInfo = [
            "gameName": "Sunday Football",
            "venueName": "Sydney Football Centre",
            "status": "Updated"
        ]

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        try await UNUserNotificationCenter.current()
            .add(request)
    }

    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .badge, .sound]
            )
    }
}
