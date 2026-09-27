//
//  CommunityRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

protocol CommunityRepository {
    func fetchCommunity(id: UUID) async throws -> Community?
    func createCommunity(_ community: Community) async throws
    func updateCommunity(_ community: Community) async throws
}