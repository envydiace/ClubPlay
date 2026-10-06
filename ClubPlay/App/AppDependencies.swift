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
    let supabaseRegistrationRepository: SupabaseWeeklyGameRegistrationRepository
    let membershipRepository: SupabaseCommunityMembershipRepository
    let memberRepository: SupabaseClubMemberRepository
    let communityRepository: SupabaseCommunityRepository
    let authRepository: SupabaseAuthRepository

    // MARK: - Cache

    let gameCache: CoreDataGameCache
    let registrationCache: CoreDataRegistrationCache

    // MARK: - App-facing repositories

    let gameRepository: WeeklyFootballGameRepository
    let registrationRepository: WeeklyGameRegistrationRepository

    private init() {

        // Supabase
        supabaseGameRepository =
            SupabaseWeeklyFootballGameRepository()

        supabaseRegistrationRepository =
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
        
        registrationCache = CoreDataRegistrationCache()

        // Combined repository
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
    }
}
