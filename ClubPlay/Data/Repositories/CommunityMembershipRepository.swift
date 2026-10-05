//
//  CommunityMembershipRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

protocol CommunityMembershipRepository {
    func fetchMembership(
        memberID: UUID,
        communityID: UUID
    ) async throws -> CommunityMembership?

    func fetchMemberships(
        forCommunityID communityID: UUID
    ) async throws -> [CommunityMembership]
    
    func fetchMemberships(
        forMemberID memberID: UUID
    ) async throws -> [CommunityMembership]

    func createMembership(
        _ membership: CommunityMembership
    ) async throws

    func updateMembership(
        _ membership: CommunityMembership
    ) async throws
}
