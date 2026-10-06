//
//  AuthViewModel.swift
//  ClubPlay
//
//  Created by Đức Anh on 5/10/26.
//


import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUserID: UUID?
    
    @Published var currentMember: ClubMember?
    
    @Published var currentMembership: CommunityMembership?
    @Published var currentCommunity: Community?

    private let signInUseCase: SignInUseCase
    private let signOutUseCase: SignOutUseCase

    private let memberRepository: ClubMemberRepository
    private let membershipRepository: CommunityMembershipRepository
    private let communityRepository: CommunityRepository
    
    init(
        signInUseCase: SignInUseCase,
        signOutUseCase: SignOutUseCase,
        memberRepository: ClubMemberRepository,
        membershipRepository: CommunityMembershipRepository,
        communityRepository: CommunityRepository
    ) {
        self.signInUseCase = signInUseCase
        self.signOutUseCase = signOutUseCase
        self.memberRepository = memberRepository
        self.membershipRepository = membershipRepository
        self.communityRepository = communityRepository
    }

    func signIn() async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        do {
            let userID = try await signInUseCase.execute(
                email: email,
                password: password
            )

            currentUserID = userID
            currentMember = try await memberRepository.fetchMember(id: userID)
            let memberships = try await membershipRepository.fetchMemberships(
                forMemberID: userID
            )

            if let membership = memberships.first {
                currentMembership = membership

                currentCommunity = try await communityRepository.fetchCommunity(
                    id: membership.communityID
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await signOutUseCase.execute()

            currentUserID = nil
            currentMember = nil
            currentMembership = nil
            currentCommunity = nil

            email = ""
            password = ""

            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
