//
//  MockMemberBanRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation
@testable import ClubPlay

final class MockMemberBanRepository: MemberBanRepository {
    var bans: [MemberBan] = []

    func fetchActiveBan(
        forMemberID memberID: UUID,
        at date: Date
    ) async throws -> MemberBan? {
        bans.first {
            $0.memberID == memberID &&
            $0.startedAt <= date &&
            $0.endsAt > date
        }
    }

    func fetchBans(
        forMemberID memberID: UUID
    ) async throws -> [MemberBan] {
        bans.filter { $0.memberID == memberID }
    }

    func createBan(_ ban: MemberBan) async throws {
        bans.append(ban)
    }
}