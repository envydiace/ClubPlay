//
//  SignUpUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation

struct SignUpUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(
        email: String,
        password: String,
        fullName: String
    ) async throws -> UUID {
        try await authRepository.signUp(
            email: email,
            password: password,
            fullName: fullName
        )
    }
}