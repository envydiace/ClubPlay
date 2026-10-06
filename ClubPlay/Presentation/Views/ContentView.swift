//
//  ContentView.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//

import SwiftUI

struct ContentView: View {
    let member: ClubMember
    let membership: CommunityMembership
    let community: Community

    let dependencies: AppDependencyProviding

    let onSignOut: () -> Void

    var body: some View {
        TabView {
            NavigationStack {
                UpcomingGamesView(
                    viewModel: UpcomingGamesViewModel(
                        gameRepository: dependencies.gameRepository,
                        registrationRepository:
                            dependencies.registrationRepository
                    ),
                    communityID: community.id,
                    memberID: member.id,
                    dependencies: dependencies
                )
            }
            .tabItem {
                Label("Games", systemImage: "sportscourt")
            }

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
        }
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
