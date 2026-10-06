//
//  SupabaseAuthRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Supabase

final class SupabaseAuthRepository: AuthRepository {
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseManager.shared.client) {
        self.client = client
    }
    
    func signIn(
        email: String,
        password: String
    ) async throws -> UUID {
        let session = try await client.auth.signIn(
            email: email,
            password: password
        )

        return session.user.id
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    func currentUserID() async throws -> UUID? {
        client.auth.currentUser?.id
    }
}
