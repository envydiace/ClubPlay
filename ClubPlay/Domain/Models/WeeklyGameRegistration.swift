//
//  WeeklyGameRegistration.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct WeeklyGameRegistration: Identifiable, Codable, Equatable {
    let id: UUID

    let memberID: UUID
    let gameID: UUID

    var registrationStatus: RegistrationStatus
    var attendanceStatus: AttendanceStatus

    let registeredAt: Date
    var updatedAt: Date
}