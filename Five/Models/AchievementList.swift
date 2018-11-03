//
//  AchievementList.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Daniel Andrews. All rights reserved.
//

import UIKit

class AchievementList: NSObject {
    static var achievementList: [Achievement] = []
    
    static func setAchievements() {
        let achievements = [
            Achievement(name: "First Task Created", desc: "Create your first task!", action: AchievementAction.create, count: 1),
            Achievement(name: "Five Created", desc: "Create 5 tasks", action: AchievementAction.create, count: 5),
            Achievement(name: "Ten Created", desc: "Create 10 tasks", action: AchievementAction.create, count: 10),
            Achievement(name: "Fifty Created", desc: "Create any 50 tasks", action: AchievementAction.create, count: 50),
            Achievement(name: "First Completed", desc: "Complete your first task!", action: AchievementAction.complete, count: 1),
            Achievement(name: "Five Completed", desc: "Complete 5 tasks", action: AchievementAction.complete, count: 5),
            Achievement(name: "Ten Completed", desc: "Complete 10 tasks", action: AchievementAction.complete, count: 10),
            Achievement(name: "Fifty Completed", desc: "Complete 50 tasks", action: AchievementAction.complete, count: 50),
            Achievement(name: "Hit your daily goal", desc: "Complete 5 tasks in one day", action: AchievementAction.daily, count: 1),
            Achievement(name: "Hit your daily goal 5 times", desc: "Complete 5 tasks in one day, 5 times", action: AchievementAction.daily, count: 5),
            Achievement(name: "Hit your daily goal 10 times", desc: "Complete 5 tasks in one day, 10 times", action: AchievementAction.daily, count: 10),
            Achievement(name: "Hit your daily goal 5 times", desc: "Complete 5 tasks in one day, 50 times", action: AchievementAction.daily, count: 50),
        ]
        
        achievements.compactMap { achievementList.append($0) }
    }
    
    static func checkComplete() -> [Achievement] {
        let uncompleted: [Achievement] = achievementList.filter { $0.completed == false }
        let newlyCompleted = uncompleted.filter { $0.checkCompleted() == true }
        return newlyCompleted
    }
    
    override init() {
        
    }
}
