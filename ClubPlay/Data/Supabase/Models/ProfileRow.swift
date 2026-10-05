//
//  ProfileRow.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation

struct ProfileRow: Codable {
    let id: UUID
    let fullName: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
    }

    func toDomain() -> ClubMember {
        ClubMember(
            id: id,
            fullName: fullName,
            emailAddress: email
        )
    }
}