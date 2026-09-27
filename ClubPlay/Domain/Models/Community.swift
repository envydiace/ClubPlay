//
//  Community.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

struct Community: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    let createdAt: Date
    let createdByMemberID: UUID
}