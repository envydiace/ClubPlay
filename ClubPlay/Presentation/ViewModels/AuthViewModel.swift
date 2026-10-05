//
//  AuthViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUserID: UUID?

    private let signUpUseCase: SignUpUseCase
    private let signInUseCase: SignInUseCase
    private let signOutUseCase: SignOutUseCase

    init(
        signUpUseCase: SignUpUseCase,
        signInUseCase: SignInUseCase,
        signOutUseCase: SignOutUseCase
    ) {
        self.signUpUseCase = signUpUseCase
        self.signInUseCase = signInUseCase
        self.signOutUseCase = signOutUseCase
    }

    func signUp() async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            currentUserID = try await signUpUseCase.execute(
                email: email,
                password: password,
                fullName: fullName
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn() async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            currentUserID = try await signInUseCase.execute(
                email: email,
                password: password
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await signOutUseCase.execute()
            currentUserID = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
