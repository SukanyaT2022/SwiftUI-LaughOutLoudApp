//
//  NewJokeModel.swift
//  DailyJoke
//
//  Created by TS2 on 4/1/26.
//

import Foundation
// MARK: - Joke Models
struct Joke: Codable, Hashable{
    let question: String
    let answer: String
}
