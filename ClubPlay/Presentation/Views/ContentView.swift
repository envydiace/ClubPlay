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
    
    let onSignOut: () -> Void

    var body: some View {
        TabView {
            NavigationStack {
                Text("Upcoming Games")
                    .navigationTitle("Games")
            }
            .tabItem {
                Label("Games", systemImage: "sportscourt")
            }

            NavigationStack {
                Text("My Registrations")
                    .navigationTitle("My Games")
            }
            .tabItem {
                Label("My Games", systemImage: "checkmark.circle")
            }

            if membership.role == .organiser {
                NavigationStack {
                    Text("Manage Games")
                        .navigationTitle("Manage")
                }
                .tabItem {
                    Label("Manage", systemImage: "slider.horizontal.3")
                }
            }

            NavigationStack {
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 72))

                    Text(member.fullName)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(member.emailAddress)
                        .foregroundStyle(.secondary)

                    Text(community.name)
                        .font(.headline)

                    Text(membership.role.rawValue.capitalized)
                        .foregroundStyle(.secondary)

                    Button("Sign Out", role: .destructive) {
                        onSignOut()
                    }
                    .padding(.top)
                }
                .padding()
                .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

#Preview("Organiser") {
    ContentView(
        member: MockData.member,
        membership: MockData.organiserMembership,
        community: MockData.community,
        onSignOut: { }
    )
}

#Preview("Member") {
    ContentView(
        member: MockData.member,
        membership: MockData.memberMembership,
        community: MockData.community,
        onSignOut: { }
    )
}
