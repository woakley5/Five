//
//  MainViewController-Feed.swift
//  Five
//
//  Created by Will Oakley on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {

    func initFeedCells() {
        let tasks = TaskList.getTasksByStatus(status: TaskStatus.active)
        for i in 0..<tasks.count {
            createFeedCell(task: tasks[i], addToSubview: false)
        }
        
        var zVal = backgroundGradientView.layer.zPosition + 5
        for card in feedCards {
            card.layer.zPosition = CGFloat(zVal)
            zVal = zVal - 1
        }
        
        for card in feedCards {
            card.isHidden = true
            self.view.addSubview(card)
        }
        
        feedExpanded = false
        for (i, card) in feedCards.enumerated() {
            let yVal = (100 * i) + 100
            let width = Int(self.view.frame.width - 40)
            card.frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            let deadlineTime = DispatchTime.now() + .milliseconds(200 * i)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                card.isHidden = false
            }
        }
        for (i, card) in feedCards.enumerated() {
            let deadlineTime = DispatchTime.now() + .milliseconds(200 * i)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.view.addSubview(card)
                card.animate()
            }
        }
    }
    
    func createFeedCell(task: Task, addToSubview: Bool) {
        let i = feedCards.count
        let gradients: [GRADIENT] = [PERSONAL_BLUE_GRADIENT(), WORK_ORANGE_GRADIENT(), FINANCE_GREEN_GRADIENT(), HOME_RED_GRADIENT()]
        let gradient: GRADIENT
        if task.tag == .personal {
            gradient = gradients[0]
        } else if task.tag == .work {
            gradient = gradients[1]
        } else if task.tag == .finance {
            gradient = gradients[2]
        } else {
            gradient = gradients[3]
        }
        let yVal = (100 * i) + 100
        let width = Int(self.view.frame.width - 40)
        let card = TaskCellView(frame: CGRect(x: 20, y: yVal, width: width, height: 80), gradient: gradient, task: task)
        feedCards.append(card)
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedFeedCell(sender:)))
        //card.addGestureRecognizer(tapGestureRecognizer)
        card.animation = "slideUp"
        card.duration = 1.0
        card.completeButton.addTarget(self, action: #selector(markTaskAsDone(sender:)), for: .touchUpInside)
        
        var zVal = backgroundGradientView.layer.zPosition + 5
        for card in feedCards {
            card.layer.zPosition = CGFloat(zVal)
            zVal = zVal - 1
        }
        
        card.completeButton.tag = i
        card.tag = i
        
        if addToSubview {
            view.addSubview(card)
            card.animate()
        }
    }

    func dismissFeedCells(completion: @escaping () -> Void) {
        feedExpanded = false
        let width = Int(self.view.frame.width - 40)
        let awayFrame = CGRect(x: 20, y: 1000, width: width, height: 80)
        for card in feedCards {
            let deadlineTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                card.animate(toFrame: awayFrame) {
                    card.removeFromSuperview()
                }
            }
        }
        feedCards.removeAll()
        completion()
    }
    
    func expandAndShowAddAnimation() {
        feedExpanded = true
        for i in (0..<feedCards.count) {
            let yVal = (20 * i) + 400
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            let deadlineTime = DispatchTime.now()
            feedCards[i].completeButton.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.feedCards[i].animate(toFrame: frame) {
                    print("Done animating expand")
                }
            }
        }
        addEventCell.animate()
    }
    
    func resetAllFeedCardsAnimation() {
        feedExpanded = false
        for (i, card) in feedCards.enumerated() {
            print("the value of i is \(i)")
            card.completeButton.isUserInteractionEnabled = true
            let yVal = (100 * i) + 100
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            card.animate(toFrame: frame) {
                print("Done animating reset")
            }
        }
    }
    
    func showAddEvent() {
        addButton.setImage(UIImage(named:"cancelIcon"), for: .normal)
        addEventCell = AddEventCellView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.width - 100), controller: self)
        view.addSubview(addEventCell)
        addEventCell.doneButton.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
        expandAndShowAddAnimation()
    }
    
    @objc func saveEvent() {
        //TODO: get data from addEventCell and save to Task and TaskList
        if let text = addEventCell.nameField.text {
            // TODO: ALSO NEED TO GET THE TAG. TAG SHOULD BE REQUIRED. PARSE FOR TAG AND RETURN ERROR IF INCORRECT
            // TODO: CHECK FOR DATE HERE
            // if let dueDate = <date> {
            //   // code
            // else {
            TaskList.createTask(text: text, tag: .work)
            if feedCards.count < 5 {
                let list = TaskList.getTasksByStatus(status: .active)
                createFeedCell(task: list[list.count - 1], addToSubview: true)
            }
            
            dismissAddEvent()
        } else {
            print("Missing field")
        }
    }
    
    func dismissAddEvent() {
        addButton.setImage(UIImage(named:"addIcon"), for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            self.addEventCell.frame = CGRect(x: 500, y: 100, width: self.view.frame.width - 40, height: self.view.frame.width - 100)
        }) { (done) in
            self.feedExpanded = false
            self.addEventCell.removeFromSuperview()
            self.resetAllFeedCardsAnimation()
        }
    }
    
    @objc func markTaskAsDone(sender: UIButton) {
        let card = feedCards[sender.tag]
        card.task.completeTask()
        UIView.animate(withDuration: 0.25, animations: {
            card.frame = CGRect(x: card.frame.maxX + 500, y: card.frame.minY, width: card.frame.width, height: card.frame.height)
        }) { (done) in
            card.removeFromSuperview()
            self.feedCards.remove(at: sender.tag)
            for i in 0..<self.feedCards.count {
                self.feedCards[i].tag = i
                self.feedCards[i].completeButton.tag = i
            }
            self.advanceFeed(removedIndex: sender.tag)
        }
    }
    
    func advanceFeed(removedIndex: Int) {
        print("Removed event " + String(removedIndex))
        
        for x in removedIndex..<feedCards.count {
            let cardFrame = self.feedCards[x].frame
            UIView.animate(withDuration: 0.5) {
                self.feedCards[x].frame = CGRect(x: cardFrame.minX, y: cardFrame.minY - 100, width: cardFrame.width, height: cardFrame.height)
            }
        }
        
        if let newTask = TaskList.getNextActive() {
            createFeedCell(task: newTask, addToSubview: true)
        }
    }
    
    @objc func tappedFeedCell(sender: UITapGestureRecognizer) {
        let view = sender.view as! TaskCellView
        let tag = view.tag
        if tag == 0 {
            if feedExpanded {
                resetAllFeedCardsAnimation()
            } else {
                expandAndShowAddAnimation()
            }
        }
    }
    
    func dismissFeedState(completion: @escaping () -> Void) {
        if feedExpanded {
            dismissAddEvent()
        }
        dismissFeedCells {
            completion()
        }
    }

}
