//
//  GameStatus.swift
//  ClubPlay
//
//  Created by Đức Anh on 27/9/26.
//


enum GameStatus: String, Codable {
    case draft
    case published
    case closed
    case cancelled
}