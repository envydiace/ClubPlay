//
//  GetActiveBanUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct GetActiveBanUseCase {
    private let banRepository: MemberBanRepository

    init(banRepository: MemberBanRepository) {
        self.banRepository = banRepository
    }

    func execute(
        memberID: UUID,
        currentDate: Date = Date()
    ) async throws -> MemberBan? {
        try await banRepository.fetchActiveBan(
            forMemberID: memberID,
            at: currentDate
        )
    }
}