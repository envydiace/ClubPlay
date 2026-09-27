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