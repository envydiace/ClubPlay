//
//  AuthView.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    TextField("Full name", text: $viewModel.fullName)

                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $viewModel.password)
                }
                
                if let member = viewModel.currentMember {
                    Section("Profile") {
                        Text(member.fullName)
                        Text(member.emailAddress)
                    }
                }
                
                if let membership = viewModel.currentMembership,
                   let community = viewModel.currentCommunity {

                    Section("Community") {
                        Text(community.name)
                        Text(membership.role.rawValue.capitalized)
                    }
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

                if let userID = viewModel.currentUserID {
                    Section("Signed In") {
                        Text(userID.uuidString)

                        Button("Sign Out") {
                            Task {
                                await viewModel.signOut()
                            }
                        }
                    }
                }
            }
            .navigationTitle("ClubPlay")
            .disabled(viewModel.isLoading)
        }
    }
}
