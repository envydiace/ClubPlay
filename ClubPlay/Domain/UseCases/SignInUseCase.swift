//
//  SignInUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation

struct SignInUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(
        email: String,
        password: String
    ) async throws -> UUID {
        try await authRepository.signIn(
            email: email,
            password: password
        )
    }
}