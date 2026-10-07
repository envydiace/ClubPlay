//
//  ContentView.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .games
    @State private var notificationGame: WeeklyFootballGame?
    @State private var gamesPath: [UUID] = []
    
    let member: ClubMember
    let membership: CommunityMembership
    let community: Community

    let dependencies: AppDependencyProviding

    let onSignOut: () -> Void

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $gamesPath) {
                UpcomingGamesView(
                    viewModel: UpcomingGamesViewModel(
                        gameRepository: dependencies.gameRepository,
                        registrationRepository:
                            dependencies.registrationRepository
                    ),
                    openedGame: notificationGame,
                    communityID: community.id,
                    memberID: member.id,
                    dependencies: dependencies
                )
                .navigationDestination(for: UUID.self) { gameID in
                    if let game = notificationGame,
                       game.id == gameID {

                        gameDetailView(for: game)

                    } else {
                        ProgressView()
                    }
                }
            }
            .tabItem {
                Label("Games", systemImage: "sportscourt")
            }
            .tag(Tab.games)

            NavigationStack {
                MyRegistrationsView(
                    viewModel: MyRegistrationsViewModel(
                        registrationRepository:
                            dependencies.registrationRepository,
                        gameRepository:
                            dependencies.gameRepository,
                        widgetSyncService: dependencies.widgetSyncService
                    ),
                    memberID: member.id,
                    dependencies: dependencies
                )
            }
            .tabItem {
                Label("My Games", systemImage: "checkmark.circle")
            }
            .tag(Tab.myGames)

            if membership.role == .organiser {
                NavigationStack {
                    ManageGamesView(
                        viewModel: ManageGamesViewModel(
                            gameRepository: dependencies.gameRepository,
                            publishGameUseCase: PublishGameUseCase(
                                gameRepository: dependencies.gameRepository,
                                membershipRepository:
                                    dependencies.membershipRepository
                            )
                        ),
                        communityID: community.id,
                        organiserID: member.id,
                        dependencies: dependencies
                    )
                }
                .tabItem {
                    Label("Manage", systemImage: "slider.horizontal.3")
                }
                .tag(Tab.manage)
            }
            NavigationStack {
                ProfileView(
                    member: member,
                    membership: membership,
                    community: community,
                    onSignOut: onSignOut
                )
            }
            .tabItem {
                Label(
                    "Profile",
                    systemImage: "person.circle"
                )
            }
            .tag(Tab.profile)
        }
        .onReceive(
            NotificationService.shared.$openedGameID
        ) { gameID in

            guard let gameID else {
                return
            }

            Task {
                guard let game =
                    try? await dependencies.gameRepository
                        .fetchGame(id: gameID)
                else {
                    return
                }

                await MainActor.run {
                    notificationGame = game
                    selectedTab = .games

                    NotificationService.shared.openedGameID = nil
                }
            }
        }
    }
    
    private enum Tab {
        case games
        case myGames
        case manage
        case profile
    }
    
    private func gameDetailView(
        for game: WeeklyFootballGame
    ) -> some View {
        let gameRepository =
            dependencies.gameRepository

        let registrationRepository =
            dependencies.registrationRepository

        let promoteUseCase =
            PromoteWaitlistedPlayerUseCase(
                registrationRepository:
                    registrationRepository
            )

        let cancelUseCase =
            CancelGameRegistrationUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository,
                promoteWaitlistedPlayerUseCase:
                    promoteUseCase
            )

        let registerUseCase =
            RegisterForGameUseCase(
                gameRepository: gameRepository,
                registrationRepository:
                    registrationRepository
            )

        return GameDetailView(
            game: game,
            memberID: member.id,
            viewModel: GameDetailViewModel(
                registerForGameUseCase:
                    registerUseCase,
                cancelGameRegistrationUseCase:
                    cancelUseCase,
                registrationRepository:
                    registrationRepository,
                widgetSyncService:
                    dependencies.widgetSyncService
            )
        )
    }
}

#Preview("Organiser") {
    ContentView(
        member: MockData.member,
        membership: MockData.organiserMembership,
        community: MockData.community,
        dependencies: PreviewDependencies(),
        onSignOut: { }
    )
}

#Preview("Member") {
    ContentView(
        member: MockData.member,
        membership: MockData.memberMembership,
        community: MockData.community,
        dependencies: PreviewDependencies(),
        onSignOut: { }
    )
}
