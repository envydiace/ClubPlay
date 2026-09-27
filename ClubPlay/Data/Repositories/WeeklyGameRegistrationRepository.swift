//
//  WeeklyGameRegistrationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

protocol WeeklyGameRegistrationRepository {
    func fetchRegistration(
        memberID: UUID,
        gameID: UUID
    ) async throws -> WeeklyGameRegistration?

    func fetchRegistrations(
        forGameID gameID: UUID
    ) async throws -> [WeeklyGameRegistration]

    func fetchRegistrations(
        forMemberID memberID: UUID
    ) async throws -> [WeeklyGameRegistration]

    func saveRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws

    func updateRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws
}