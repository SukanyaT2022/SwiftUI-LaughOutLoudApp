//
//  NewJokeModel.swift
//  DailyJoke
//
//  Created by TS2 on 4/1/26.
//
import SwiftData
import Foundation
// MARK: - Joke Models

struct Joke: Codable, Hashable{
    let question: String
    let answer: String
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
}

extension Joke: Identifiable {
    var id: String { "\(question)|\(answer)" }
}
@Model
class NewJokeModelSwiftDataModel{
    var question: String
    var answer: String
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
}
