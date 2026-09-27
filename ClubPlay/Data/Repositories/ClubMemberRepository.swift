//
//  ClubMemberRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

protocol ClubMemberRepository {
    func fetchMember(id: UUID) async throws -> ClubMember?
    func fetchMember(cloudUserRecordName: String) async throws -> ClubMember?
    func saveMember(_ member: ClubMember) async throws
}