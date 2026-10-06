//
//  CachedClubMemberRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

final class CachedClubMemberRepository: ClubMemberRepository {
    private let remoteRepository: ClubMemberRepository
    private let profileCache: CoreDataProfileCache

    init(
        remoteRepository: ClubMemberRepository,
        profileCache: CoreDataProfileCache
    ) {
        self.remoteRepository = remoteRepository
        self.profileCache = profileCache
    }

    func fetchMember(id: UUID) async throws -> ClubMember? {
        do {
            let member = try await remoteRepository.fetchMember(id: id)

            if let member {
                try profileCache.save(member)
            }

            return member
        } catch {
            return try profileCache.fetch(id: id)
        }
    }
}