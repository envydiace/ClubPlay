//
//  MockNotificationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
@testable import ClubPlay

@MainActor
final class MockNotificationRepository:
    NotificationRepository {

    var sentNotifications: [ClubNotification] = []

    func send(
        _ notification: ClubNotification
    ) async throws {
        sentNotifications.append(notification)
    }
}