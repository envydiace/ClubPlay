//
//  WeeklyGameRegistrationRow.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

struct WeeklyGameRegistrationRow: Codable {
    let id: UUID
    let memberID: UUID
    let gameID: UUID
    let registrationStatus: String
    let attendanceStatus: String
    let registeredAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "member_id"
        case gameID = "game_id"
        case registrationStatus = "registration_status"
        case attendanceStatus = "attendance_status"
        case registeredAt = "registered_at"
        case updatedAt = "updated_at"
    }

    func toDomain() -> WeeklyGameRegistration {
        WeeklyGameRegistration(
            id: id,
            memberID: memberID,
            gameID: gameID,
            registrationStatus: RegistrationStatus(rawValue: registrationStatus) ?? .cancelled,
            attendanceStatus: AttendanceStatus(rawValue: attendanceStatus) ?? .absent,
            registeredAt: registeredAt,
            updatedAt: updatedAt
        )
    }

    static func fromDomain(
        _ registration: WeeklyGameRegistration
    ) -> Self {
        Self(
            id: registration.id,
            memberID: registration.memberID,
            gameID: registration.gameID,
            registrationStatus: registration.registrationStatus.rawValue,
            attendanceStatus: registration.attendanceStatus.rawValue,
            registeredAt: registration.registeredAt,
            updatedAt: registration.updatedAt
        )
    }
}