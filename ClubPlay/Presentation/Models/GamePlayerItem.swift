//
//  GamePlayerItem.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

struct GamePlayerItem: Identifiable {
    let registration: WeeklyGameRegistration
    let member: ClubMember

    var id: UUID {
        registration.id
    }
}