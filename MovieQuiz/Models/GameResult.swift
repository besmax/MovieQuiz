//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 10.12.2025.
//
import UIKit

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
            correct > another.correct
        }
}
