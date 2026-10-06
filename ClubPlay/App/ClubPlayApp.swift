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
            let dependencies = AppDependencies.shared

            AuthView(
                viewModel: AuthViewModel(
                    signInUseCase: SignInUseCase(
                        authRepository: dependencies.authRepository
                    ),
                    signOutUseCase: SignOutUseCase(
                        authRepository: dependencies.authRepository
                    ),
                    memberRepository: dependencies.memberRepository,
                    membershipRepository: dependencies.membershipRepository,
                    communityRepository: dependencies.communityRepository,
                    widgetSyncService: dependencies.widgetSyncService
                ),
                dependencies: dependencies
            )
        }
    }
}
