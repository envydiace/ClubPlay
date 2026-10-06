//
//  CachedWeeklyGameRegistrationRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

final class CachedWeeklyGameRegistrationRepository:
    WeeklyGameRegistrationRepository {

    private let remoteRepository: WeeklyGameRegistrationRepository
    private let registrationCache: CoreDataRegistrationCache

    init(
        remoteRepository: WeeklyGameRegistrationRepository,
        registrationCache: CoreDataRegistrationCache
    ) {
        self.remoteRepository = remoteRepository
        self.registrationCache = registrationCache
    }

    func fetchRegistration(
        id: UUID
    ) async throws -> WeeklyGameRegistration? {

        do {
            let result = try await remoteRepository.fetchRegistration(id: id)

            if let result {
                try registrationCache.save(result)
            }

            return result
        } catch {
            // We don't currently have a cache lookup by registration ID.
            throw error
        }
    }

    func fetchRegistration(
        memberID: UUID,
        gameID: UUID
    ) async throws -> WeeklyGameRegistration? {

        do {
            let result = try await remoteRepository.fetchRegistration(
                memberID: memberID,
                gameID: gameID
            )

            if let result {
                try registrationCache.save(result)
            }

            return result
        } catch {
            return try registrationCache.fetchRegistration(
                memberID: memberID,
                gameID: gameID
            )
        }
    }

    func fetchRegistrations(
        forGameID gameID: UUID
    ) async throws -> [WeeklyGameRegistration] {

        do {
            let registrations =
                try await remoteRepository.fetchRegistrations(
                    forGameID: gameID
                )

            try registrationCache.save(registrations)

            return registrations
        } catch {
            return try registrationCache.fetchRegistrations(
                forGameID: gameID
            )
        }
    }

    func fetchRegistrations(
        forMemberID memberID: UUID
    ) async throws -> [WeeklyGameRegistration] {

        do {
            let registrations =
                try await remoteRepository.fetchRegistrations(
                    forMemberID: memberID
                )

            try registrationCache.save(registrations)

            return registrations
        } catch {
            return try registrationCache.fetchRegistrations(
                forMemberID: memberID
            )
        }
    }

    func saveRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {

        try await remoteRepository.saveRegistration(registration)

        try registrationCache.save(registration)
    }

    func updateRegistration(
        _ registration: WeeklyGameRegistration
    ) async throws {

        try await remoteRepository.updateRegistration(registration)

        try registrationCache.save(registration)
    }

    func promoteNextWaitlistedPlayer(
        gameID: UUID
    ) async throws -> UUID? {
        try await remoteRepository.promoteNextWaitlistedPlayer(
            gameID: gameID
        )
    }
}