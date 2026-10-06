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

                VStack(spacing: 12) {
                    Image(systemName: "sportscourt.fill")
                        .font(.system(size: 58))
                        .foregroundStyle(.blue)

                    Text("ClubPlay")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Sign in to access your community games")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Welcome Back")
                        .font(.title3)
                        .fontWeight(.semibold)

                    TextField(
                        "Email",
                        text: $viewModel.email
                    )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textFieldStyle(.roundedBorder)

                    SecureField(
                        "Password",
                        text: $viewModel.password
                    )
                    .textContentType(.password)
                    .textFieldStyle(.roundedBorder)
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
                .disabled(
                    viewModel.isLoading ||
                    viewModel.email.isEmpty ||
                    viewModel.password.isEmpty
                )

                Text(
                    "Accounts are provided by your ClubPlay community organiser."
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
            communityRepository: dependencies.communityRepository,
            widgetSyncService: dependencies.widgetSyncService
        ),
        dependencies: dependencies
    )
}
