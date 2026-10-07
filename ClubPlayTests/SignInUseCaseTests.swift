//
//  SignInUseCaseTests.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//


import Foundation
import Testing
@testable import ClubPlay

@MainActor
@Suite("SignInUseCase")
struct SignInUseCaseTests {

    @Test("Member signs in with valid credentials")
    func memberSignsInSuccessfully() async throws {
        let expectedUserID = UUID()

        let authRepository =
            MockAuthRepository()

        authRepository.signedInUserID =
            expectedUserID

        let useCase = SignInUseCase(
            authRepository: authRepository
        )

        let result = try await useCase.execute(
            email: "member@clubplay.com",
            password: "Password123"
        )

        #expect(result == expectedUserID)

        #expect(
            authRepository.receivedEmail
                == "member@clubplay.com"
        )

        #expect(
            authRepository.receivedPassword
                == "Password123"
        )
    }
}