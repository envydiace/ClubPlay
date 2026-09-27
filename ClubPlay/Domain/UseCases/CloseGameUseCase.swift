//
//  CloseGameUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct CloseGameUseCase {
    private let gameRepository: WeeklyFootballGameRepository
    private let registrationRepository: WeeklyGameRegistrationRepository
    private let membershipRepository: CommunityMembershipRepository
    private let banRepository: MemberBanRepository

    init(
        gameRepository: WeeklyFootballGameRepository,
        registrationRepository: WeeklyGameRegistrationRepository,
        membershipRepository: CommunityMembershipRepository,
        banRepository: MemberBanRepository
    ) {
        self.gameRepository = gameRepository
        self.registrationRepository = registrationRepository
        self.membershipRepository = membershipRepository
        self.banRepository = banRepository
    }

    func execute(
        gameID: UUID,
        requestingMemberID: UUID,
        membersToBan: Set<UUID>,
        banUntil: Date,
        currentDate: Date = Date()
    ) async throws {

        guard var game = try await gameRepository.fetchGame(id: gameID) else {
            throw GameManagementError.gameNotFound
        }

        guard let membership =
                try await membershipRepository.fetchMembership(
                    memberID: requestingMemberID,
                    communityID: game.communityID
                ),
              membership.role == .organiser
        else {
            throw BanError.unauthorised
        }

        guard game.status != .cancelled else {
            throw GameManagementError.gameCancelled
        }

        guard game.status != .closed else {
            throw GameManagementError.gameAlreadyClosed
        }

        guard currentDate >= game.finishesAt else {
            throw GameManagementError.gameNotFinished
        }

        guard banUntil > currentDate else {
            throw BanError.invalidBanEndDate
        }

        let registrations =
            try await registrationRepository.fetchRegistrations(
                forGameID: gameID
            )

        let eligibleAbsentRegistrations = registrations.filter {
            $0.registrationStatus == .confirmed &&
            $0.attendanceStatus == .absent
        }

        let eligibleMemberIDs = Set(
            eligibleAbsentRegistrations.map(\.memberID)
        )

        guard membersToBan.isSubset(of: eligibleMemberIDs) else {
            throw BanError.memberNotEligibleForBan
        }

        for memberID in membersToBan {
            let ban = MemberBan(
                id: UUID(),
                communityID: game.communityID,
                memberID: memberID,
                sourceGameID: game.id,
                startedAt: currentDate,
                endsAt: banUntil,
                reason: .absence,
                createdByMemberID: requestingMemberID,
                createdAt: currentDate
            )

            try await banRepository.createBan(ban)
        }

        game.status = .closed

        try await gameRepository.updateGame(game)
    }
}