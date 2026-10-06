//
//  MemberBanRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

protocol MemberBanRepository {
    func fetchActiveBan(
        forMemberID memberID: UUID,
        at date: Date
    ) async throws -> MemberBan?

    func fetchBans(
        forMemberID memberID: UUID
    ) async throws -> [MemberBan]

    func createBan(_ ban: MemberBan) async throws
}