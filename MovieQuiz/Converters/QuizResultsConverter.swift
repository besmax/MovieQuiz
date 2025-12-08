//
//  QuizResultsConverter.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 08.12.2025.
//

extension QuizResultsViewModel {
    
    func toAlertModel(onButtonClick: @escaping () -> Void) -> AlertModel {
        let alertAction = AlertAction(title: self.buttonText, action: onButtonClick)
        
        return AlertModel(
            title: self.title,
            message: self.text,
            actions: [alertAction]
        )
    }
}
