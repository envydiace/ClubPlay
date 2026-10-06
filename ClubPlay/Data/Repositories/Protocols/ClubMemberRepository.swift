//
//  ClubMemberRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

protocol ClubMemberRepository {
    func fetchMember(id: UUID) async throws -> ClubMember?
}
