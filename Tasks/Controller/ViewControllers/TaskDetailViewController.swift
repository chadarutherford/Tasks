//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Chad Rutherford on 12/16/19.
//  Copyright © 2019 Chad Rutherford. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTask()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private
    private func updateViews() {
        title = task?.name ?? "Create Task"
        guard let task = task, self.isViewLoaded else { return }
        nameTextField.text = task.name
        notesTextView.text = task.notes
        let priority: TaskPriority
        if let taskPriority = task.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        prioritySegmentedControl.selectedSegmentIndex = TaskPriority.allPriorities.firstIndex(of: priority) ?? 1
    }
    
    private func saveTask() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let notes = notesTextView.text
        let priorityIndex = prioritySegmentedControl.selectedSegmentIndex
        let priority = TaskPriority.allPriorities[priorityIndex]
        
        if let task = task {
            task.name = name
            task.notes = notes
            task.priority = priority.rawValue
        } else {
            let _ = Task(name: name, notes: notes, priority: priority)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch let dataError {
            print("Error saving managed object context: \(dataError.localizedDescription)")
        }
    }
}
