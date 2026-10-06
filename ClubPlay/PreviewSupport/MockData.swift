//
//  MockData.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

enum MockData {
    static let memberID = UUID()
    static let communityID = UUID()

    static let member = ClubMember(
        id: memberID,
        fullName: "Preview User",
        emailAddress: "preview@clubplay.test"
    )

    static let community = Community(
        id: communityID,
        name: "ClubPlay Preview Community",
        createdAt: Date(),
        createdByMemberID: memberID
    )

    static let organiserMembership = CommunityMembership(
        id: UUID(),
        memberID: memberID,
        communityID: communityID,
        role: .organiser,
        joinedAt: Date()
    )

    static let memberMembership = CommunityMembership(
        id: UUID(),
        memberID: memberID,
        communityID: communityID,
        role: .member,
        joinedAt: Date()
    )
}
