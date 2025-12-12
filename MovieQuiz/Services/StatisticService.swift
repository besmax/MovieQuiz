//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 10.12.2025.
//

import UIKit

final class StatisticService : StatisticServiceProtocol {
    private let dataSource: StatisticDataSourceLocalProtocol = StatisticDataSourceLocal()
    
    var gamesCount: Int {
        get {
            dataSource.getValueByKey(StatisticKey.gamesCount, defaultValue: -1)
        }
        set {
            dataSource.setValueByKey(val: newValue, key: StatisticKey.gamesCount)
        }
    }
    
    var bestGame: GameResult  {
        get {
            let date: Date = dataSource.getValueByKey(StatisticKey.bestGameDate, defaultValue: Date())
            let correct: Int = dataSource.getValueByKey(StatisticKey.bestGameCorrect, defaultValue: -1)
            let total: Int = dataSource.getValueByKey(StatisticKey.bestGameTotal, defaultValue: -1)
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            dataSource.setValueByKey(val: newValue.date, key: StatisticKey.bestGameDate)
            dataSource.setValueByKey(val: newValue.correct, key: StatisticKey.bestGameCorrect)
            dataSource.setValueByKey(val: newValue.total, key: StatisticKey.bestGameTotal)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correct: Int = dataSource.getValueByKey(StatisticKey.totalCorrectAnswers, defaultValue: -1)
            let total: Int = dataSource.getValueByKey(StatisticKey.totalQuestionsAsked, defaultValue: -1)
            return Double(correct) / Double(total) * 100.0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newTotalCorrectAnswers = dataSource.getValueByKey(StatisticKey.totalCorrectAnswers, defaultValue: 0) + count
        let newTotalQuestionsAsked = dataSource.getValueByKey(StatisticKey.totalQuestionsAsked, defaultValue: 0) + amount
        
        dataSource.setValueByKey(val: newTotalCorrectAnswers, key: StatisticKey.totalCorrectAnswers)
        dataSource.setValueByKey(val: newTotalQuestionsAsked, key: StatisticKey.totalQuestionsAsked)
        
        let newGamesCount = gamesCount + 1
        gamesCount = newGamesCount
        
        let current = GameResult(correct: count, total: amount, date: Date())
        if (current.isBetterThan(bestGame)) { bestGame = current }
    }
}
