//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 08.12.2025.
//

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error) 
}
