//
//  AlertControllerFactory.swift
//  TaskListApp
//
//  Created by Варвара Уткина on 07.11.2024.
//

import UIKit

protocol AlertFactoryProtocol {
    func createAlert(completion: @escaping(String) -> Void) -> UIAlertController
}

final class AlertControllerFactory: AlertFactoryProtocol {
    let userAction: UserAction
    let taskTitle: String?
    
    init(userAction: UserAction, taskTitle: String?) {
        self.userAction = userAction
        self.taskTitle = taskTitle
    }
    
    func createAlert(completion: @escaping (String) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: userAction.title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alertController.textFields?.first?.text else { return }
            guard !task.isEmpty else { return }
            completion(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { [unowned self] textField in
            textField.placeholder = "Task"
            textField.text = taskTitle
        }
        
        return alertController
    }
    
}


// MARK: - UserAction
extension AlertControllerFactory {
    enum UserAction {
        case editTask
        case newTask
        
        var title: String {
            switch self {
            case .editTask: "Edit Task"
            case .newTask: "New Task"
            }
        }
    }
}
