//
//  MockData.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

enum MockData {
    static let memberID = UUID()
    static let communityID = UUID()

    static let member = ClubMember(
        id: memberID,
        fullName: "Preview User",
        emailAddress: "preview@clubplay.test"
    )

    static let community = Community(
        id: communityID,
        name: "ClubPlay Preview Community",
        createdAt: Date(),
        createdByMemberID: memberID
    )

    static let organiserMembership = CommunityMembership(
        id: UUID(),
        memberID: memberID,
        communityID: communityID,
        role: .organiser,
        joinedAt: Date()
    )

    static let memberMembership = CommunityMembership(
        id: UUID(),
        memberID: memberID,
        communityID: communityID,
        role: .member,
        joinedAt: Date()
    )
    
    static let game1ID = UUID()
    static let game2ID = UUID()

    static let upcomingGames: [WeeklyFootballGame] = [
        WeeklyFootballGame(
            id: game1ID,
            communityID: communityID,
            gameName: "Sunday Football",
            venueName: "Sydney Football Centre",
            kickOffAt: Date().addingTimeInterval(86_400),
            finishesAt: Date().addingTimeInterval(93_600),
            playerCapacity: 22,
            registrationOpensAt: Date().addingTimeInterval(-86_400),
            registrationClosesAt: Date().addingTimeInterval(82_800),
            cancellationDeadlineHours: 2,
            status: .published,
            createdAt: Date(),
            createdByMemberID: memberID
        ),

        WeeklyFootballGame(
            id: game2ID,
            communityID: communityID,
            gameName: "Wednesday Night Game",
            venueName: "UTS Sports Field",
            kickOffAt: Date().addingTimeInterval(259_200),
            finishesAt: Date().addingTimeInterval(266_400),
            playerCapacity: 18,
            registrationOpensAt: Date().addingTimeInterval(-86_400),
            registrationClosesAt: Date().addingTimeInterval(255_600),
            cancellationDeadlineHours: 2,
            status: .published,
            createdAt: Date(),
            createdByMemberID: memberID
        )
    ]
    
    static let registrations: [WeeklyGameRegistration] = [
        WeeklyGameRegistration(
            id: UUID(),
            memberID: memberID,
            gameID: game1ID,
            registrationStatus: .confirmed,
            attendanceStatus: .absent,
            registeredAt: Date(),
            updatedAt: Date()
        ),

        WeeklyGameRegistration(
            id: UUID(),
            memberID: memberID,
            gameID: game2ID,
            registrationStatus: .waitlisted,
            attendanceStatus: .absent,
            registeredAt: Date(),
            updatedAt: Date()
        )
    ]
}
