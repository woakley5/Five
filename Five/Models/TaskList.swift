//
//  TaskList.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit

class TaskList: NSObject {
    static var taskList: [Task] = []
    
    func addSampleTasks() {
        let calendar = Calendar.current

        var components = DateComponents()

        components.day = 4
        components.month = 11
        components.year = 2018
        components.hour = 12
        components.minute = 0

        let newDate = calendar.date(from: components)

        createTask(text: "Read Huck Finn chapters 1-5")
        createTask(text: "Win Cal Hacks!", dueDate: newDate!)
        createTask(text: "Fix login screen bug in todo app")
        
        components.day = 5
        let newDate1 = calendar.date(from: components)
        createTask(text: "Allow more than 5 todos?", dueDate: newDate1!)
        createTask(text: "Call mom back")
        
        components.month = 10
        components.day = 28
        let newDate2 = calendar.date(from: components)
        createTask(text: "Find dress for wedding", dueDate: newDate2!)
    }
    
    func createTask(text: String) {
        let task = Task(text: text)
        createTaskHelper(task)
    }
    
    func createTask(text: String, dueDate: Date) {
        let task = Task(text: text, dueDate: dueDate)
        createTaskHelper(task)
    }
    
    func createTaskHelper(_ task: Task) {
        TaskList.taskList.append(task)
    }
    
    func getTasksByStatus(status: TaskStatus) -> [Task] {
        return TaskList.taskList.filter { $0.status == status }
    }
}
