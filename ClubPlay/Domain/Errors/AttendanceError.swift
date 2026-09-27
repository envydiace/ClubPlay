//
//  AttendanceError.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

enum AttendanceError: Error, Equatable {
    case unauthorised
    case registrationNotConfirmed
    case gameNotFinished
}