//
//  NotificationService.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//

import Foundation
import UserNotifications
import Combine

enum NotificationCategory {
    static let gameUpdate = "CLUBPLAY_GAME_UPDATE"
}

final class NotificationService:
    NSObject,
    ObservableObject,
    UNUserNotificationCenterDelegate {

    static let shared = NotificationService()

    @Published var openedGameID: UUID?

    private override init() {
        super.init()
    }

    func configure() {
        let category = UNNotificationCategory(
            identifier: NotificationCategory.gameUpdate,
            actions: [],
            intentIdentifiers: [],
            options: []
        )

        let center = UNUserNotificationCenter.current()

        center.setNotificationCategories([category])
        center.delegate = self
    }

    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .badge, .sound]
            )
    }

    // Notification tapped
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler:
            @escaping () -> Void
    ) {
        let userInfo =
            response.notification.request.content.userInfo

        if
            let gameIDString = userInfo["gameID"] as? String,
            let gameID = UUID(uuidString: gameIDString)
        {
            DispatchQueue.main.async {
                self.openedGameID = gameID
            }
        }

        completionHandler()
    }

    // Useful during development:
    // also show notifications while ClubPlay is foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([
            .banner,
            .sound
        ])
    }
}
