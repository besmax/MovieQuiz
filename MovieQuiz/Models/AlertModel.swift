//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Максим Беспалов on 08.12.2025.
//
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let actions: [AlertAction]
    
    init(title: String, message: String, actions: [AlertAction] ) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: () -> Void
    
    init(title: String, style: UIAlertAction.Style = UIAlertAction.Style.default, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
}
