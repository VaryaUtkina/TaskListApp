//
//  ViewController.swift
//  TaskListApp
//
//  Created by Варвара Уткина on 06.11.2024.
//

import UIKit

enum Alert {
    case save
    case edit
    
    var title: String {
        switch self {
        case .save: "New Task"
        case .edit: "Edit task"
        }
    }
    
}

final class TaskListViewController: UITableViewController {
    private var taskList: [ToDoTask] = []
    private let cellID = "task"
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        fetchData()
    }
    
    @objc private func addNewTask() {
        showAlert(.save) { textField in
            textField.placeholder = "New task"
        } closure: { [unowned self] taskName in
            save(taskName)
        }

    }
    
    private func fetchData() {
        let fetchRequest = ToDoTask.fetchRequest()
        
        do {
            taskList = try storageManager.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    private func showAlert(_ alert: Alert, completion: @escaping(UITextField) -> Void, closure: @escaping(String) -> Void) {
        let alert = UIAlertController(
            title: alert.title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { _ in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            closure(taskName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            completion(textField)
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        let task = ToDoTask(context: storageManager.persistentContainer.viewContext)
        task.title = taskName
        taskList.append(task)
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        storageManager.saveContext()
    }
    
    private func edit(_ taskName: String, at indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        task.title = taskName
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        storageManager.saveContext()
    }
    
    private func delete(taskAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        storageManager.persistentContainer.viewContext.delete(task)
        taskList.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        storageManager.saveContext()
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let toDoTask = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = toDoTask.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(.edit) { [unowned self] textField in
            textField.text = taskList[indexPath.row].title
        } closure: { [unowned self] taskName in
            edit(taskName, at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(taskAt: indexPath)
        }
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = .milkBlue
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}
