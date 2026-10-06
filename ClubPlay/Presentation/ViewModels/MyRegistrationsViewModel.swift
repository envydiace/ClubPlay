//
//  MyRegistrationsViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation
import Combine

@MainActor
final class MyRegistrationsViewModel: ObservableObject {
    @Published var registrations: [WeeklyGameRegistration] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let registrationRepository: WeeklyGameRegistrationRepository

    init(
        registrationRepository: WeeklyGameRegistrationRepository
    ) {
        self.registrationRepository = registrationRepository
    }

    func loadRegistrations(
        memberID: UUID
    ) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            registrations = try await registrationRepository
                .fetchRegistrations(forMemberID: memberID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
