//
//  CachedCommunityMembershipRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//

import Foundation

final class CachedCommunityMembershipRepository:
    CommunityMembershipRepository {

    private let remoteRepository: CommunityMembershipRepository
    private let membershipCache: CoreDataCommunityMembershipCache

    init(
        remoteRepository: CommunityMembershipRepository,
        membershipCache: CoreDataCommunityMembershipCache
    ) {
        self.remoteRepository = remoteRepository
        self.membershipCache = membershipCache
    }

    func fetchMembership(
        memberID: UUID,
        communityID: UUID
    ) async throws -> CommunityMembership? {
        do {
            let membership =
                try await remoteRepository.fetchMembership(
                    memberID: memberID,
                    communityID: communityID
                )

            if let membership {
                try membershipCache.save(membership)
            }

            return membership
        } catch {
            return try membershipCache.fetch(
                memberID: memberID,
                communityID: communityID
            )
        }
    }

    func fetchMemberships(
        forCommunityID communityID: UUID
    ) async throws -> [CommunityMembership] {
        do {
            let memberships =
                try await remoteRepository.fetchMemberships(
                    forCommunityID: communityID
                )

            try membershipCache.save(memberships)

            return memberships
        } catch {
            return try membershipCache.fetch(
                forCommunityID: communityID
            )
        }
    }

    func fetchMemberships(
        forMemberID memberID: UUID
    ) async throws -> [CommunityMembership] {
        do {
            let memberships =
                try await remoteRepository.fetchMemberships(
                    forMemberID: memberID
                )

            try membershipCache.save(memberships)

            return memberships
        } catch {
            return try membershipCache.fetch(
                forMemberID: memberID
            )
        }
    }

    func createMembership(
        _ membership: CommunityMembership
    ) async throws {
        try await remoteRepository.createMembership(membership)

        try membershipCache.save(membership)
    }

    func updateMembership(
        _ membership: CommunityMembership
    ) async throws {
        try await remoteRepository.updateMembership(membership)

        try membershipCache.save(membership)
    }
}
