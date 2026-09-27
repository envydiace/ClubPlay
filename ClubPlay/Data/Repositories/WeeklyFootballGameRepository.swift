//
//  WeeklyFootballGameRepository.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


import Foundation

protocol WeeklyFootballGameRepository {
    func fetchUpcomingGames() async throws -> [WeeklyFootballGame]
    func fetchGame(id: UUID) async throws -> WeeklyFootballGame?
    
    func createGame(_ game: WeeklyFootballGame) async throws
    func updateGame(_ game: WeeklyFootballGame) async throws
}