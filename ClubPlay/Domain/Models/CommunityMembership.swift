//
//  CommunityMembership.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct CommunityMembership: Identifiable, Codable, Equatable {
    let id: UUID
    let memberID: UUID
    let communityID: UUID
    var role: ClubMemberRole
    let joinedAt: Date
}