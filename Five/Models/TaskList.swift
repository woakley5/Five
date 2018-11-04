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
    
    static func addSampleTasks() {
        let calendar = Calendar.current

        var components = DateComponents()

        components.day = 4
        components.month = 11
        components.year = 2018
        components.hour = 12
        components.minute = 0

        let newDate = calendar.date(from: components)

        createTask(text: "Read Huck Finn chapters 1-5", tag: .work)
        createTask(text: "Win Cal Hacks!", tag: .personal, dueDate: newDate!)
        createTask(text: "Fix login screen bug in todo app", tag: .work)
        
        components.day = 5
        let newDate1 = calendar.date(from: components)
        createTask(text: "Allow more than 5 todos?", tag: .work, dueDate: newDate1!)
        createTask(text: "Pay phone bill", tag: .finance)
        
        components.month = 10
        components.day = 28
        let newDate2 = calendar.date(from: components)
        createTask(text: "Find dress for wedding", tag: .home, dueDate: newDate2!)
    }
    
    static func createTask(text: String, tag: TaskTag) {
        let task = Task(text: text, tag: tag)
        TaskList.createTaskHelper(task)
    }
    
    static func createTask(text: String, tag: TaskTag, dueDate: Date) {
        let task = Task(text: text, tag: tag, dueDate: dueDate)
        TaskList.createTaskHelper(task)
    }
    
    static func createTaskHelper(_ task: Task) {
        if getTasksByStatus(status: .active).count < 5 {
            task.status = .active
        }
        taskList.append(task)
        NotificationCenter.default.post(name: .taskAdded, object: nil)
    }
    
    static func getTasksByStatus(status: TaskStatus) -> [Task] {
        return taskList.filter { $0.status == status }
    }
    
    static func getBacklogTasksByTag(tag: TaskTag) -> [Task] {
        return taskList.filter { $0.tag == tag && $0.status == .backlog}
    }
    
    static func getCompletedTasksByTag(tag: TaskTag) -> [Task] {
        return taskList.filter { $0.tag == tag && $0.status == .completed}
    }
    
    static func getCompletedToday() -> Int {
        let completed = getTasksByStatus(status: .completed)
        
        let date = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        return completed.filter { $0.completeDate != nil && $0.completeDate! > startOfDay }.count
    }
    
    static func getNumTasksCompleted() -> Int {
        return taskList.filter { $0.status == .completed }.count
    }
    
    static func getNextActive() -> Task? {
        let active = getTasksByStatus(status: .active)
        if active.count >= 5 {
            return nil
        }
        
        let backlog = getTasksByStatus(status: TaskStatus.backlog)
        
        if backlog.count > 0 {
            let newActive = backlog[0]
            newActive.switchStatus(status: .active)
            return newActive
        }
        
        return nil
    }
}
