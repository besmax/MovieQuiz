//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 08.12.2025.
//
import UIKit

final class AlertPresenter {
    
    func show(
        _ model: AlertModel,
        present: (UIAlertController) -> Void
    ) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        for actionModel in model.actions {
            let action = UIAlertAction(title: actionModel.title, style: .default) { _ in
                actionModel.action()
            }
            alert.addAction(action)
        }
        
        present(alert)
    }
    
}
