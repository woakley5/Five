//
//  Achievement.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Daniel Andrews. All rights reserved.
//

import UIKit

enum AchievementAction {
    case create
    case complete
    case streak
    case daily
}

class Achievement: NSObject {
    var name: String!
    var desc: String!
    var dateAchieved: Date?
    var timesAchieved = 0
    var progress = 0
    var completed = false
    
    var action: AchievementAction!
    var count: Int!
    
    init(name: String, desc: String, action: AchievementAction, count: Int) {
        self.name = name
        self.desc = desc
        self.action = action
        self.count = count
    }
    
    func checkCompleted() -> Bool {
        var didComplete = false
        switch action {
        case .create?:
            didComplete = TaskList.taskList.count > count
            break
        case .complete?:
            didComplete = TaskList.getNumTasksCompleted() > count
            break
        case .daily?:
            // This does NOT work. Buggy implementation created for hackathon purposes
            // TODO: fix me so it works by looking at days
            didComplete = TaskList.getCompletedToday() > count
        default:
            return false
        }
        completed = didComplete
        return didComplete
    }
}
