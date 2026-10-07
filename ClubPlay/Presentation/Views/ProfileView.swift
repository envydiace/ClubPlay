//
//  ProfileView.swift
//  ClubPlay
//
//  Created by Đức Anh on 6/10/26.
//


import SwiftUI

struct ProfileView: View {
    let member: ClubMember
    let membership: CommunityMembership
    let community: Community

    let onSignOut: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                accountCard
                communityCard
                signOutButton
            }
            .padding()
        }
        .navigationTitle("Profile")
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 84))
                .foregroundStyle(.secondary)

            Text(member.fullName)
                .font(.title2)
                .fontWeight(.bold)

            Text(member.emailAddress)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var accountCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(
                "Account",
                systemImage: "person"
            )
            .font(.headline)

            Divider()

            profileRow(
                title: "Name",
                value: member.fullName
            )

            profileRow(
                title: "Email",
                value: member.emailAddress
            )
        }
        .profileCard()
    }

    private var communityCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(
                "Community",
                systemImage: "person.3"
            )
            .font(.headline)

            Divider()

            profileRow(
                title: "Community",
                value: community.name
            )

            HStack {
                Text("Role")
                    .foregroundStyle(.secondary)

                Spacer()

                Text(
                    membership.role.rawValue.capitalized
                )
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(roleColor.opacity(0.12))
                )
                .foregroundStyle(roleColor)
            }
        }
        .profileCard()
    }

    private var signOutButton: some View {
        Button(role: .destructive) {
            onSignOut()
        } label: {
            Label(
                "Sign Out",
                systemImage: "rectangle.portrait.and.arrow.right"
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }

    private func profileRow(
        title: String,
        value: String
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
    }

    private var roleColor: Color {
        membership.role == .organiser
            ? .purple
            : .blue
    }
}

private extension View {
    func profileCard() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        Color(
                            uiColor:
                                .secondarySystemBackground
                        )
                    )
            )
    }
}
