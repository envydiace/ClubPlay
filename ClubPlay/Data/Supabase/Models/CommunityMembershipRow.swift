//
//  CommunityMembershipRow.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation

struct CommunityMembershipRow: Codable {
    let id: UUID
    let memberID: UUID
    let communityID: UUID
    let role: String
    let joinedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "member_id"
        case communityID = "community_id"
        case role
        case joinedAt = "joined_at"
    }

    func toDomain() -> CommunityMembership {
        CommunityMembership(
            id: id,
            memberID: memberID,
            communityID: communityID,
            role: ClubMemberRole(rawValue: role) ?? .member,
            joinedAt: joinedAt
        )
    }
}