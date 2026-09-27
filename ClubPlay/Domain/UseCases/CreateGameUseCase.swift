//
//  CreateGameUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct CreateGameUseCase {
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
        game: WeeklyFootballGame,
        requestingMemberID: UUID
    ) async throws {
        guard let membership = try await membershipRepository.fetchMembership(
            memberID: requestingMemberID,
            communityID: game.communityID
        ) else {
            throw GameManagementError.unauthorised
        }

        guard membership.role == .organiser else {
            throw GameManagementError.unauthorised
        }

        guard game.playerCapacity > 0 else {
            throw GameManagementError.invalidCapacity
        }

        guard game.finishesAt > game.kickOffAt else {
            throw GameManagementError.invalidGameTime
        }

        guard game.registrationOpensAt < game.registrationClosesAt else {
            throw GameManagementError.invalidRegistrationWindow
        }

        guard game.registrationClosesAt <= game.kickOffAt else {
            throw GameManagementError.invalidRegistrationWindow
        }

        try await gameRepository.createGame(game)
    }
}