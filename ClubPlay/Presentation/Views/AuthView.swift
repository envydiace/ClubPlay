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
        NavigationStack {
            Form {
                Section("Account") {
                    TextField(
                        "Full name",
                        text: $viewModel.fullName
                    )

                    TextField(
                        "Email",
                        text: $viewModel.email
                    )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                    SecureField(
                        "Password",
                        text: $viewModel.password
                    )
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }

                Section {
                    Button("Sign Up") {
                        Task {
                            await viewModel.signUp()
                        }
                    }

                    Button("Sign In") {
                        Task {
                            await viewModel.signIn()
                        }
                    }
                }
            }
            .navigationTitle("ClubPlay")
            .disabled(viewModel.isLoading)
        }
    }
}

#Preview("Signed Out") {
    let dependencies = PreviewDependencies()

    AuthView(
        viewModel: AuthViewModel(
            signUpUseCase: SignUpUseCase(
                authRepository: dependencies.authRepository
            ),
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
