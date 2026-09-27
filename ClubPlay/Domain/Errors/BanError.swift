//
//  BanError.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

enum BanError: Error, Equatable {
    case unauthorised
    case invalidBanEndDate
    case memberNotEligibleForBan
}