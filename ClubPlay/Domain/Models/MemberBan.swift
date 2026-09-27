//
//  MemberBan.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct MemberBan: Identifiable, Codable, Equatable {
    let id: UUID

    let memberID: UUID
    let sourceGameID: UUID

    let startedAt: Date
    var endsAt: Date

    let reason: BanReason

    let createdByMemberID: UUID
    let createdAt: Date
}