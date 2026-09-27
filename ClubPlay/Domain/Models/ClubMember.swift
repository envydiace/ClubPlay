//
//  ClubMember.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct ClubMember: Identifiable, Codable, Equatable {
    let id: UUID
    let fullName: String
    let emailAddress: String
    let cloudUserRecordName: String?
}
