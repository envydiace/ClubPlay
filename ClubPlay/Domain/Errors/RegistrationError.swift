//
//  RegistrationError.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

enum RegistrationError: Error, Equatable {
    case memberBanned(until: Date)
    case registrationNotOpen
    case registrationClosed
    case duplicateRegistration
    case registrationNotFound
    case cancellationDeadlinePassed
    case gameCancelled
    case noWaitlistedPlayer
    case invalidStatusChange
}
