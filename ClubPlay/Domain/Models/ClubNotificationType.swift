//
//  ClubNotificationType.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


enum ClubNotificationType: String, Codable {
    case newGamePublished
    case gameUpdated
    case registrationOpened
    case waitlistPromoted
}