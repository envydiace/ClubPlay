//
//  ClubNotification.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

struct ClubNotification: Equatable {
    let recipientMemberIDs: [UUID]
    let type: ClubNotificationType
    let title: String
    let message: String
    let relatedGameID: UUID?
}