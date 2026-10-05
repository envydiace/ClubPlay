//
//  GameManagementError.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

enum GameManagementError: Error, Equatable {
    case unauthorised
    case invalidCapacity
    case invalidGameTime
    case invalidRegistrationWindow
    case gameNotFound
    case gameAlreadyClosed
    case gameCancelled
    case gameNotFinished
}

extension GameManagementError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unauthorised:
            return "You are not authorised to perform this action."

        case .invalidCapacity:
            return "Player capacity must be greater than zero."

        case .invalidGameTime:
            return "The finish time must be after the kick-off time."

        case .invalidRegistrationWindow:
            return "Registration must open before it closes and close before the game starts."

        case .gameNotFound:
            return "The game could not be found."

        case .gameAlreadyClosed:
            return "This game has already been closed."

        case .gameCancelled:
            return "This game has been cancelled."

        case .gameNotFinished:
            return "The game has not finished yet."
        }
    }
}
