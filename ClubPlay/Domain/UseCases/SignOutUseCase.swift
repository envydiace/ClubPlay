//
//  SignOutUseCase.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


struct SignOutUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async throws {
        try await authRepository.signOut()
    }
}