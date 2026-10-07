//
//  MockAuthRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 7/10/26.
//

import Foundation
@testable import ClubPlay

@MainActor
final class MockAuthRepository: AuthRepository {

    var signedInUserID: UUID?
    var currentUserIDValue: UUID?

    var receivedEmail: String?
    var receivedPassword: String?

    var signOutCalled = false

    func signIn(
        email: String,
        password: String
    ) async throws -> UUID {
        receivedEmail = email
        receivedPassword = password

        return signedInUserID ?? UUID()
    }

    func signOut() async throws {
        signOutCalled = true
    }

    func currentUserID() async throws -> UUID? {
        currentUserIDValue
    }
}
