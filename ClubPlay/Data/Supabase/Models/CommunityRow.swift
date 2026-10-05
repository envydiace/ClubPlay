//
//  CommunityRow.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation

struct CommunityRow: Codable {
    let id: UUID
    let name: String
    let createdAt: Date
    let createdBy: UUID

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case createdBy = "created_by"
    }

    func toDomain() -> Community {
        Community(
            id: id,
            name: name,
            createdAt: createdAt,
            createdByMemberID: createdBy
        )
    }
}