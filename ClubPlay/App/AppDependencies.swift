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

    let supabaseGameRepository: SupabaseWeeklyFootballGameRepository
    let registrationRepository: SupabaseWeeklyGameRegistrationRepository
    let membershipRepository: SupabaseCommunityMembershipRepository
    let memberRepository: SupabaseClubMemberRepository
    let communityRepository: SupabaseCommunityRepository
    let authRepository: SupabaseAuthRepository

    // MARK: - Cache

    let gameCache: CoreDataGameCache

    // MARK: - App-facing repositories

    let gameRepository: WeeklyFootballGameRepository

    private init() {

        // Supabase
        supabaseGameRepository =
            SupabaseWeeklyFootballGameRepository()

        registrationRepository =
            SupabaseWeeklyGameRegistrationRepository()

        membershipRepository =
            SupabaseCommunityMembershipRepository()

        memberRepository =
            SupabaseClubMemberRepository()

        communityRepository =
            SupabaseCommunityRepository()

        authRepository =
            SupabaseAuthRepository()

        // Core Data
        gameCache = CoreDataGameCache()

        // Combined repository
        gameRepository =
            CachedWeeklyFootballGameRepository(
                remoteRepository: supabaseGameRepository,
                gameCache: gameCache
            )
    }
}