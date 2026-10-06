//
//  PreviewDependencies.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


final class PreviewDependencies: AppDependencyProviding {
    let authRepository: AuthRepository
    let memberRepository: ClubMemberRepository
    let membershipRepository: CommunityMembershipRepository
    let communityRepository: CommunityRepository

    let gameRepository: WeeklyFootballGameRepository
    let registrationRepository: WeeklyGameRegistrationRepository

    init() {
        authRepository = PreviewAuthRepository()
        memberRepository = PreviewClubMemberRepository()
        membershipRepository =
            PreviewCommunityMembershipRepository()
        communityRepository =
            PreviewCommunityRepository()
        gameRepository =
            PreviewGameRepository()
        registrationRepository =
            PreviewRegistrationRepository()
    }
}