//
//  LocalNotificationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//

import Foundation
import UserNotifications

final class LocalNotificationRepository: NotificationRepository {

    func send(
        _ notification: ClubNotification
    ) async throws {

        let center = UNUserNotificationCenter.current()

        let granted = try await center.requestAuthorization(
            options: [.alert, .badge, .sound]
        )

        guard granted else {
            return
        }

        let content = UNMutableNotificationContent()

        content.title = notification.title
        content.body = notification.message
        content.sound = .default

        content.categoryIdentifier =
            NotificationCategory.gameUpdate

        if let gameID = notification.relatedGameID {
            content.userInfo["gameID"] = gameID.uuidString
        }

        if let gameName = notification.gameName {
            content.userInfo["gameName"] = gameName
        }

        if let previousVenueName =
            notification.previousVenueName {

            content.userInfo["previousVenueName"] =
                previousVenueName
        }

        if let updatedVenueName =
            notification.updatedVenueName {

            content.userInfo["updatedVenueName"] =
                updatedVenueName
        }

        if let previousKickOffAt =
            notification.previousKickOffAt {

            content.userInfo["previousKickOffAt"] =
                previousKickOffAt.timeIntervalSince1970
        }

        if let updatedKickOffAt =
            notification.updatedKickOffAt {

            content.userInfo["updatedKickOffAt"] =
                updatedKickOffAt.timeIntervalSince1970
        }

        content.userInfo["status"] = "Updated"
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }
}
