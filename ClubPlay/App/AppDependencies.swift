//
//  AppDependencies.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import Foundation

@MainActor
final class AppDependencies {
    static let shared = AppDependencies()

    // MARK: - Remote repositories

    let supabaseMemberRepository:
        SupabaseClubMemberRepository

    let supabaseCommunityRepository:
        SupabaseCommunityRepository

    let supabaseMembershipRepository:
        SupabaseCommunityMembershipRepository

    let supabaseGameRepository:
        SupabaseWeeklyFootballGameRepository

    let supabaseRegistrationRepository:
        SupabaseWeeklyGameRegistrationRepository

    // MARK: - Core Data caches

    let profileCache:
        CoreDataProfileCache

    let communityCache:
        CoreDataCommunityCache

    let membershipCache:
        CoreDataCommunityMembershipCache

    let gameCache:
        CoreDataGameCache

    let registrationCache:
        CoreDataRegistrationCache

    // MARK: - App-facing repositories

    let memberRepository:
        ClubMemberRepository

    let communityRepository:
        CommunityRepository

    let membershipRepository:
        CommunityMembershipRepository

    let gameRepository:
        WeeklyFootballGameRepository

    let registrationRepository:
        WeeklyGameRegistrationRepository

    let authRepository:
        AuthRepository

    private init() {
        supabaseMemberRepository =
            SupabaseClubMemberRepository()

        supabaseCommunityRepository =
            SupabaseCommunityRepository()

        supabaseMembershipRepository =
            SupabaseCommunityMembershipRepository()

        supabaseGameRepository =
            SupabaseWeeklyFootballGameRepository()

        supabaseRegistrationRepository =
            SupabaseWeeklyGameRegistrationRepository()

        profileCache =
            CoreDataProfileCache()

        communityCache =
            CoreDataCommunityCache()

        membershipCache =
            CoreDataCommunityMembershipCache()

        gameCache =
            CoreDataGameCache()

        registrationCache =
            CoreDataRegistrationCache()

        memberRepository =
            CachedClubMemberRepository(
                remoteRepository: supabaseMemberRepository,
                profileCache: profileCache
            )

        communityRepository =
            CachedCommunityRepository(
                remoteRepository: supabaseCommunityRepository,
                communityCache: communityCache
            )

        membershipRepository =
            CachedCommunityMembershipRepository(
                remoteRepository: supabaseMembershipRepository,
                membershipCache: membershipCache
            )

        gameRepository =
            CachedWeeklyFootballGameRepository(
                remoteRepository: supabaseGameRepository,
                gameCache: gameCache
            )

        registrationRepository =
            CachedWeeklyGameRegistrationRepository(
                remoteRepository: supabaseRegistrationRepository,
                registrationCache: registrationCache
            )

        authRepository =
            SupabaseAuthRepository()
    }
}
