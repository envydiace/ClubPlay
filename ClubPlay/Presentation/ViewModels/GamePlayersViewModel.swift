//
//  GamePlayersViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation
import Combine

@MainActor
final class GamePlayersViewModel: ObservableObject {
    @Published var players: [GamePlayerItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let registrationRepository: WeeklyGameRegistrationRepository
    private let memberRepository: ClubMemberRepository

    init(
        registrationRepository: WeeklyGameRegistrationRepository,
        memberRepository: ClubMemberRepository
    ) {
        self.registrationRepository = registrationRepository
        self.memberRepository = memberRepository
    }

    func loadPlayers(gameID: UUID) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let registrations =
                try await registrationRepository.fetchRegistrations(
                    forGameID: gameID
                )

            var result: [GamePlayerItem] = []

            for registration in registrations {
                guard let member =
                        try await memberRepository.fetchMember(
                            id: registration.memberID
                        )
                else {
                    continue
                }

                result.append(
                    GamePlayerItem(
                        registration: registration,
                        member: member
                    )
                )
            }

            players = result

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
