//
//  MyRegistrationItem.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

struct MyRegistrationItem: Identifiable {
    let registration: WeeklyGameRegistration
    let game: WeeklyFootballGame

    var id: UUID {
        registration.id
    }
}