//
//  PublishGameUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct PublishGameUseCase {
    private let gameRepository: WeeklyFootballGameRepository
    private let membershipRepository: CommunityMembershipRepository

    init(
        gameRepository: WeeklyFootballGameRepository,
        membershipRepository: CommunityMembershipRepository
    ) {
        self.gameRepository = gameRepository
        self.membershipRepository = membershipRepository
    }

    func execute(
        gameID: UUID,
        requestingMemberID: UUID
    ) async throws {
        guard var game = try await gameRepository.fetchGame(id: gameID) else {
            throw GameManagementError.gameNotFound
        }

        guard let membership = try await membershipRepository.fetchMembership(
            memberID: requestingMemberID,
            communityID: game.communityID
        ) else {
            throw GameManagementError.unauthorised
        }

        guard membership.role == .organiser else {
            throw GameManagementError.unauthorised
        }

        guard game.status == .draft else {
            if game.status == .cancelled {
                throw GameManagementError.gameCancelled
            }

            if game.status == .closed {
                throw GameManagementError.gameAlreadyClosed
            }

            return
        }

        guard game.playerCapacity > 0 else {
            throw GameManagementError.invalidCapacity
        }

        guard game.finishesAt > game.kickOffAt else {
            throw GameManagementError.invalidGameTime
        }

        guard game.registrationOpensAt < game.registrationClosesAt,
              game.registrationClosesAt <= game.kickOffAt else {
            throw GameManagementError.invalidRegistrationWindow
        }

        game.status = .published

        try await gameRepository.updateGame(game)
    }
}