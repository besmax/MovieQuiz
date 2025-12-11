//
//  StatisticDataSourceLocal.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 10.12.2025.
//

import UIKit

protocol StatisticDataSourceLocalProtocol {
    func getValueByKey<T>(_ key: StatisticKey, defaultValue: T) -> T
    
    func setValueByKey<T>(val: T?, key: StatisticKey)
}

final class StatisticDataSourceLocal : StatisticDataSourceLocalProtocol {
    private let storage: UserDefaults = .standard
    
    func getValueByKey<T>(_ key: StatisticKey, defaultValue: T) -> T {
        return storage.object(forKey: key.rawValue) as? T ?? defaultValue
    }
    
    func setValueByKey<T>(val: T, key: StatisticKey) {
        storage.set(val, forKey: key.rawValue)
    }
    
}

enum StatisticKey: String {
    case gamesCount          // Для счётчика сыгранных игр
    case bestGameCorrect     // Для количества правильных ответов в лучшей игре
    case bestGameTotal       // Для общего количества вопросов в лучшей игре
    case bestGameDate        // Для даты лучшей игры
    case totalCorrectAnswers // Для общего количества правильных ответов за все игры
    case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
}
