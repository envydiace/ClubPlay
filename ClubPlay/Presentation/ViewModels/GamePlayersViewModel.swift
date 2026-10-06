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
    
    private let changeRegistrationStatusUseCase: ChangeRegistrationStatusUseCase
    private let markAttendanceUseCase: MarkAttendanceUseCase

    init(
        registrationRepository: WeeklyGameRegistrationRepository,
        memberRepository: ClubMemberRepository,
        changeRegistrationStatusUseCase: ChangeRegistrationStatusUseCase,
        markAttendanceUseCase: MarkAttendanceUseCase
    ) {
        self.registrationRepository = registrationRepository
        self.memberRepository = memberRepository
        self.changeRegistrationStatusUseCase = changeRegistrationStatusUseCase
        self.markAttendanceUseCase = markAttendanceUseCase
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

    func changeStatus(
        registrationID: UUID,
        newStatus: RegistrationStatus,
        organiserID: UUID,
        gameID: UUID
    ) async {
        do {
            _ = try await changeRegistrationStatusUseCase.execute(
                registrationID: registrationID,
                newStatus: newStatus,
                requestingMemberID: organiserID
            )

            await loadPlayers(gameID: gameID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func toggleAttendance(
        registration: WeeklyGameRegistration,
        organiserID: UUID,
        gameID: UUID
    ) async {
        let newStatus: AttendanceStatus =
            registration.attendanceStatus == .present
            ? .absent
            : .present

        do {
            _ = try await markAttendanceUseCase.execute(
                registrationID: registration.id,
                attendanceStatus: newStatus,
                requestingMemberID: organiserID
            )

            await loadPlayers(gameID: gameID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
