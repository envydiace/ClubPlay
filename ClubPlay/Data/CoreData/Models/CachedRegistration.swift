//
//  CachedRegistration.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import CoreData
import Foundation

@objc(CachedRegistration)
final class CachedRegistration: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var memberID: UUID?
    @NSManaged var gameID: UUID?
    @NSManaged var registrationStatus: String?
    @NSManaged var attendanceStatus: String?
    @NSManaged var registeredAt: Date?
    @NSManaged var updatedAt: Date?
    @NSManaged var lastSyncedAt: Date?
}

extension CachedRegistration {

    func toDomain() -> WeeklyGameRegistration? {
        guard
            let id,
            let memberID,
            let gameID,
            let registrationStatus,
            let status = RegistrationStatus(
                rawValue: registrationStatus
            ),
            let attendanceStatus,
            let attendance = AttendanceStatus(
                rawValue: attendanceStatus
            ),
            let registeredAt,
            let updatedAt
        else {
            return nil
        }

        return WeeklyGameRegistration(
            id: id,
            memberID: memberID,
            gameID: gameID,
            registrationStatus: status,
            attendanceStatus: attendance,
            registeredAt: registeredAt,
            updatedAt: updatedAt
        )
    }

    func update(
        from registration: WeeklyGameRegistration,
        syncedAt: Date = Date()
    ) {
        id = registration.id
        memberID = registration.memberID
        gameID = registration.gameID
        registrationStatus =
            registration.registrationStatus.rawValue
        attendanceStatus =
            registration.attendanceStatus.rawValue
        registeredAt = registration.registeredAt
        updatedAt = registration.updatedAt
        lastSyncedAt = syncedAt
    }
}
