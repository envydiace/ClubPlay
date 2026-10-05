//
//  NoOpNotificationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


final class NoOpNotificationRepository: NotificationRepository {
    func send(
        _ notification: ClubNotification
    ) async throws {
        // Temporary implementation.
        print(
            "Notification:",
            notification.title,
            notification.recipientMemberIDs
        )
    }
}
