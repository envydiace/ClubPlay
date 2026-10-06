//
//  CachedCommunityRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

final class CachedCommunityRepository: CommunityRepository {
    private let remoteRepository: CommunityRepository
    private let communityCache: CoreDataCommunityCache

    init(
        remoteRepository: CommunityRepository,
        communityCache: CoreDataCommunityCache
    ) {
        self.remoteRepository = remoteRepository
        self.communityCache = communityCache
    }

    func fetchCommunity(
        id: UUID
    ) async throws -> Community? {
        do {
            let community =
                try await remoteRepository.fetchCommunity(id: id)

            if let community {
                try communityCache.save(community)
            }

            return community
        } catch {
            return try communityCache.fetch(id: id)
        }
    }

    func createCommunity(
        _ community: Community
    ) async throws {
        try await remoteRepository.createCommunity(community)

        try communityCache.save(community)
    }

    func updateCommunity(
        _ community: Community
    ) async throws {
        try await remoteRepository.updateCommunity(community)

        try communityCache.save(community)
    }
}
