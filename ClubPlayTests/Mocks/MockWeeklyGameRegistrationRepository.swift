//
//  MockWeeklyGameRegistrationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation
@testable import ClubPlay

final class MockWeeklyGameRegistrationRepository:
    WeeklyGameRegistrationRepository {

    var registrations: [WeeklyGameRegistration] = []
    
    var promotedMemberID: UUID?
    
    var promoteNextWaitlistedPlayerCalled = false

    func fetchRegistration(
        id: UUID
    ) async throws -> WeeklyGameRegistration? {
        registrations.first { $0.id == id }
    }

    func fetchRegistration(
        memberID: UUID,
        gameID: UUID
    ) async throws -> WeeklyGameRegistration? {
        registrations.first {
            $0.memberID == memberID &&
            $0.gameID == gameID
        }
    }

    func fetchRegistrations(
        forGameID gameID: UUID
    ) async throws -> [WeeklyGameRegistration] {
        registrations.filter { $0.gameID == gameID }
    }

    func fetchRegistrations(
        forMemberID memberID: UUID
    ) async throws -> [WeeklyGameRegistration] {
        registrations.filter { $0.memberID == memberID }
    }
    
    func promoteNextWaitlistedPlayer(
        gameID: UUID
    ) async throws -> UUID? {
        promoteNextWaitlistedPlayerCalled = true
        return promotedMemberID
    }

    func saveRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {
        registrations.append(registration)
    }

    func updateRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {
        guard let index = registrations.firstIndex(
            where: { $0.id == registration.id }
        ) else {
            return
        }

        registrations[index] = registration
    }
}
