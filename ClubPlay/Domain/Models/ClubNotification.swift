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

    let gameName: String?

    let previousVenueName: String?
    let updatedVenueName: String?

    let previousKickOffAt: Date?
    let updatedKickOffAt: Date?
}
