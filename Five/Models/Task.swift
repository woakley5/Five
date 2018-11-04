//
//  Task.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit

enum TaskStatus {
    case backlog
    case active
    case completed
}

enum TaskTag: String {
    case personal = "Personal"
    case work = "Word"
    case home = "Home"
    case finance = "Finance"
}

class Task: NSObject {
    static var currentId = 1
    var id: Int!
    var text: String!
    var createDate: Date!
    var dueDate: Date?
    var completeDate: Date?
    var status: TaskStatus!
    var tag: TaskTag!
    
    init(text: String, tag: TaskTag) {
        NotificationCenter.default.post(name: .taskAdded, object: nil)
        
        self.id = Task.currentId
        Task.currentId += 1
        
        self.text = text
        self.createDate = Date()
        self.status = .backlog
        self.tag = tag
    }
    
    convenience init(text: String, tag: TaskTag, dueDate: Date) {
        self.init(text: text, tag: tag)
        self.dueDate = dueDate
    }
    
    func completeTask() {
        NotificationCenter.default.post(name: .taskCompleted, object: self)
        switchStatus(status: .completed)
    }
    
    func switchStatus(status: TaskStatus) {
        self.status = status
    }
    
    func isOverdue() -> Bool {
        return status != .completed && dueDate != nil && dueDate! < Date()
    }
}
