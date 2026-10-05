//
//  ClubPlayApp.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//

import SwiftUI

@main
struct ClubPlayApp: App {
    var body: some Scene {
        WindowGroup {
            let authRepository = SupabaseAuthRepository()
            let memberRepository = SupabaseClubMemberRepository()
            let membershipRepository = SupabaseCommunityMembershipRepository()
            let communityRepository = SupabaseCommunityRepository()
            

            AuthView(
                viewModel: AuthViewModel(
                    signUpUseCase: SignUpUseCase(
                        authRepository: authRepository
                    ),
                    signInUseCase: SignInUseCase(
                        authRepository: authRepository
                    ),
                    signOutUseCase: SignOutUseCase(
                        authRepository: authRepository
                    ),
                    memberRepository: memberRepository,
                    membershipRepository: membershipRepository,
                    communityRepository: communityRepository
                )
            )
        }
    }
}
