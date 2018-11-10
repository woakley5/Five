//
//  User.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Daniel Andrews. All rights reserved.
//

import UIKit
import BRYXBanner

class User: NSObject {
    override init() {
    }
    
    func setupListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(newlyCompletedAchievements), name: .taskAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newlyCompletedAchievements), name: .taskCompleted, object: nil)
    }
    
    @objc func newlyCompletedAchievements() {
        let newAchievements = AchievementList.checkComplete()
        print(newAchievements.compactMap { $0.name })
        for achievement in newAchievements {
            let banner = Banner(title: achievement.name, subtitle: achievement.desc, image: UIImage(named: "trophy"), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }
}

extension Notification.Name {
    static let taskAdded = Notification.Name("taskAdded")
    static let taskCompleted = Notification.Name("taskCompleted")
}
