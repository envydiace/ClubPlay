//
//  AuthRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation

protocol AuthRepository {
    func signUp(
        email: String,
        password: String,
        fullName: String
    ) async throws -> UUID

    func signIn(
        email: String,
        password: String
    ) async throws -> UUID

    func signOut() async throws

    func currentUserID() async throws -> UUID?
}