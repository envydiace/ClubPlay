//
//  AppDependencyProviding.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


protocol AppDependencyProviding {
    var authRepository: AuthRepository { get }

    var memberRepository: ClubMemberRepository { get }
    var membershipRepository: CommunityMembershipRepository { get }
    var communityRepository: CommunityRepository { get }

    var gameRepository: WeeklyFootballGameRepository { get }
    var registrationRepository: WeeklyGameRegistrationRepository { get }
    
    var widgetSyncService: WidgetSyncing { get }
    var notificationRepository: NotificationRepository { get }
}
