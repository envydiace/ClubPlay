//
//  RegistrationError.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

enum RegistrationError: Error, Equatable {
    case registrationNotOpen
    case registrationClosed
    case duplicateRegistration
    case registrationNotFound
    case cancellationDeadlinePassed
    case gameCancelled
    case noWaitlistedPlayer
    case invalidStatusChange
}

extension RegistrationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .registrationNotOpen:
            return "Registration for this game has not opened yet."

        case .registrationClosed:
            return "Registration for this game has already closed."

        case .duplicateRegistration:
            return "You are already registered for this game."

        case .registrationNotFound:
            return "No registration could be found for this game."

        case .cancellationDeadlinePassed:
            return "The cancellation deadline for this game has passed."

        case .gameCancelled:
            return "This game has been cancelled."

        case .noWaitlistedPlayer:
            return "There are no waitlisted players available to promote."

        case .invalidStatusChange:
            return "This registration status change is not allowed."
        }
    }
}
