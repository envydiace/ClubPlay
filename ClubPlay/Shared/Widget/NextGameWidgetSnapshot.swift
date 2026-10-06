//
//  NextGameWidgetSnapshot.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation

struct NextGameWidgetSnapshot: Codable {
    let gameName: String
    let venueName: String
    let kickOffAt: Date
    let registrationStatus: String
}