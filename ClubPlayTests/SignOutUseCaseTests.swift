//
//  SignOutUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Testing
@testable import ClubPlay

@MainActor
@Suite("SignOutUseCase")
struct SignOutUseCaseTests {

    @Test("Signing out delegates to the authentication repository")
    func signsOutSuccessfully() async throws {
        let authRepository =
            MockAuthRepository()

        let useCase = SignOutUseCase(
            authRepository: authRepository
        )

        try await useCase.execute()

        #expect(authRepository.signOutCalled)
    }
}