//
//  NotificationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


protocol NotificationRepository {
    func send(
        _ notification: ClubNotification
    ) async throws
}