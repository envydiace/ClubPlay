//
//  EditGameUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct EditGameUseCase {
    private let gameRepository: WeeklyFootballGameRepository
    private let membershipRepository: CommunityMembershipRepository
    private let registrationRepository: WeeklyGameRegistrationRepository
    private let notificationRepository: NotificationRepository

    init(
        gameRepository: WeeklyFootballGameRepository,
        membershipRepository: CommunityMembershipRepository,
        registrationRepository: WeeklyGameRegistrationRepository,
        notificationRepository: NotificationRepository
    ) {
        self.gameRepository = gameRepository
        self.membershipRepository = membershipRepository
        self.registrationRepository = registrationRepository
        self.notificationRepository = notificationRepository
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

        guard game.status != .closed else {
            throw GameManagementError.gameAlreadyClosed
        }

        guard game.status != .cancelled else {
            throw GameManagementError.gameCancelled
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
        
        guard let existingGame =
                try await gameRepository.fetchGame(id: game.id)
        else {
            throw GameManagementError.gameNotFound
        }

        try await gameRepository.updateGame(game)
        
        if existingGame.status == .published {
            let registrations =
                try await registrationRepository.fetchRegistrations(
                    forGameID: game.id
                )

            if existingGame.status == .published {

                let kickOffChanged =
                    existingGame.kickOffAt != game.kickOffAt

                let venueChanged =
                    existingGame.venueName != game.venueName

                let meaningfulChange =
                    kickOffChanged || venueChanged

                guard meaningfulChange else {
                    return
                }

                let registrations =
                    try await registrationRepository.fetchRegistrations(
                        forGameID: game.id
                    )

                let recipientIDs = registrations
                    .filter {
                        $0.registrationStatus == .confirmed ||
                        $0.registrationStatus == .waitlisted
                    }
                    .map(\.memberID)

                if !recipientIDs.isEmpty {

                    let notification = ClubNotification(
                        recipientMemberIDs: recipientIDs,
                        type: .gameUpdated,
                        title: "Game Updated",
                        message: "\(game.gameName) has changed. Review the new details.",
                        relatedGameID: game.id,

                        gameName: game.gameName,

                        previousVenueName:
                            venueChanged ? existingGame.venueName : nil,

                        updatedVenueName:
                            venueChanged ? game.venueName : nil,

                        previousKickOffAt:
                            kickOffChanged ? existingGame.kickOffAt : nil,

                        updatedKickOffAt:
                            kickOffChanged ? game.kickOffAt : nil
                    )

                    try await notificationRepository.send(notification)
                }
            }
        }
    }
}
