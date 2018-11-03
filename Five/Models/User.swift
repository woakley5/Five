//
//  User.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Daniel Andrews. All rights reserved.
//

import UIKit

class User: NSObject {
    override init() {
    }
    
    func setupListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(newlyCompletedAchievements), name: .taskAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newlyCompletedAchievements), name: .taskCompleted, object: nil)
    }
    
    @objc func newlyCompletedAchievements() -> [Achievement] {
        return AchievementList.checkComplete()
    }
}

extension Notification.Name {
    static let taskAdded = Notification.Name("taskAdded")
    static let taskCompleted = Notification.Name("taskCompleted")
}
