//
//  AuthView.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel

    let dependencies: AppDependencyProviding

    var body: some View {
        Group {
            if let member = viewModel.currentMember,
               let membership = viewModel.currentMembership,
               let community = viewModel.currentCommunity {

                ContentView(
                    member: member,
                    membership: membership,
                    community: community,
                    dependencies: dependencies,
                    onSignOut: {
                        Task {
                            await viewModel.signOut()
                        }
                    }
                )

            } else {
                authenticationView
            }
        }
    }

    private var authenticationView: some View {
        ScrollView {
            VStack(spacing: 28) {

                // MARK: - Header

                VStack(spacing: 10) {
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(.blue)

                    Text("ClubPlay")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Join games. Manage your club. Play together.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)

                // MARK: - Account card

                VStack(alignment: .leading, spacing: 18) {
                    Text("Account")
                        .font(.headline)

                    VStack(spacing: 14) {
                        TextField(
                            "Email",
                            text: $viewModel.email
                        )
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(.roundedBorder)

                        SecureField(
                            "Password",
                            text: $viewModel.password
                        )
                        .textFieldStyle(.roundedBorder)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            Color(
                                uiColor: .secondarySystemBackground
                            )
                        )
                )

                // MARK: - Error

                if let errorMessage = viewModel.errorMessage {
                    HStack(spacing: 10) {
                        Image(
                            systemName:
                                "exclamationmark.triangle.fill"
                        )
                        .foregroundStyle(.red)

                        Text(errorMessage)
                            .font(.subheadline)

                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.red.opacity(0.08))
                    )
                }

                // MARK: - Actions

                VStack(spacing: 12) {
                    Button {
                        Task {
                            await viewModel.signIn()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Label(
                                "Sign In",
                                systemImage: "arrow.right.circle.fill"
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(viewModel.isLoading)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(viewModel.isLoading)
                }

                Text(
                    "Use your ClubPlay account to access your community games and registrations."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            .padding()
        }
        .background(
            Color(uiColor: .systemGroupedBackground)
        )
    }
}

#Preview("Signed Out") {
    let dependencies = PreviewDependencies()

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
            communityRepository: dependencies.communityRepository
        ),
        dependencies: dependencies
    )
}
