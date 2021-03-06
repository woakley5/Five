//
//  MainViewController-Feed.swift
//  Five
//
//  Created by Will Oakley on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

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
        for card in feedCards {
            let deadlineTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                UIView.animate(withDuration: 0.3, animations: {
                    card.alpha = 0
                }, completion: { (done) in
                    card.removeFromSuperview()
                })
            }
        }
        feedCards.removeAll()
        completion()
    }
    
    func expandAndShowAddAnimation(speech: Bool = false) {
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
        if speech {
            addSpeechEventCell.animate()
        } else {
            addEventCell.animate()
        }
    }
    
    func resetAllFeedCardsAnimation() {
        feedExpanded = false
        for (i, card) in feedCards.enumerated() {
            card.completeButton.isUserInteractionEnabled = true
            let yVal = (100 * i) + 100
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            card.animate(toFrame: frame) {
//                print("Done animating reset")
            }
        }
    }
    
    func showAddEvent(speech: Bool = false) {
        if speech {
            addSpeechButton.setImage(UIImage(named:"cancelIcon"), for: .normal)
            addSpeechEventCell = AddSpeechEventCellView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.width - 100), controller: self)
            view.addSubview(addSpeechEventCell)
            addSpeechEventCell.doneButton.addTarget(self, action: #selector(saveSpeechEvent), for: .touchUpInside)
            expandAndShowAddAnimation(speech: true)
        } else {
            addButton.setImage(UIImage(named:"cancelIcon"), for: .normal)
            addEventCell = AddEventCellView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.width - 100), controller: self)
            view.addSubview(addEventCell)
            addEventCell.doneButton.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
            expandAndShowAddAnimation()
        }
    }
    
    func parseSpeech(data: String) {
        var components = data.components(separatedBy: " ")
        var tag: TaskTag = .personal
        var offset = 0
        if components.count >= 3 {
            let firstWord = components[0].lowercased()
            if firstWord == "add" {
                components = [String](components[1..<components.count])
            }
            let penultimateWord = components[components.count - 2].lowercased()
            let ultimateWord = components[components.count - 1].lowercased()
            offset += penultimateWord.length + ultimateWord.length + 2
            print(ultimateWord)
            if penultimateWord == "to" {
                switch ultimateWord {
                case "work":
                    tag = .work
                case "personal":
                    print("in personal")
                    tag = .personal
                case "finance":
                    tag = .finance
                case "home":
                    tag = .home
                default:
                    tag = .personal
                
                }
            }
        }
        let content = String(data.prefix(data.count - offset))
        TaskList.createTask(text: content, tag: tag)
        var req = "https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment"
        let key = "939c3e71491d401aa8f8ace1f405b34e"
        let documents = ["documents": [["language": "en","id": "1","text": content]]]
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": key,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        Alamofire.request(req, method: .post, parameters: documents, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            print(response.value)
            var sentiment: Double = -1
            do {
                let json = try JSON(data: response.data as! Data)
                print(json)
                print("\n\n\n\n")
                sentiment = json["documents"][0]["score"].doubleValue

            } catch {
                print("fulc")
            }

            if sentiment < 0 {
                print("we failed fam")
            }

            if sentiment < 0.5 {
                self.sendNotification(title: "Alert", subtitle: "You might want to prioritize this!")
            }
        }

    }
    
    @objc func saveSpeechEvent() {
        //TODO: get data from addEventCell and save to Task and TaskList
        if let text = addSpeechEventCell.textView.text {
            parseSpeech(data: text)
            if feedCards.count < 5  {
                let list = TaskList.getTasksByStatus(status: .active)
                createFeedCell(task: list[list.count - 1], addToSubview: true)
            }
            dismissAddEvent(speech: true)
        } else {
            print("Missing field")
        }
    }
    
    @objc func saveEvent() {
        if let text = addEventCell.nameField.text {
            // TODO: ALSO NEED TO GET THE TAG. TAG SHOULD BE REQUIRED. PARSE FOR TAG AND RETURN ERROR IF INCORRECT
            // TODO: CHECK FOR DATE HERE
            // if let dueDate = <date> {
            //   // code
            // else {
            if let dueDate = addEventCell.chosenDate {
                TaskList.createTask(text: text, tag: addEventCell.groups.selected, dueDate: dueDate)
            } else {
                TaskList.createTask(text: text, tag: addEventCell.groups.selected)
            }
            if feedCards.count < 5 {
                let list = TaskList.getTasksByStatus(status: .active)
                createFeedCell(task: list[list.count - 1], addToSubview: true)
            }
            
            dismissAddEvent()
        } else {
            print("Missing field")
        }
    }
    
    func dismissAddEvent(speech: Bool = false) {
        if speech {
            addSpeechButton.setImage(UIImage(named:"microphone"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.addSpeechEventCell.frame = CGRect(x: 500, y: 100, width: self.view.frame.width - 40, height: self.view.frame.width - 100)
            }) { (done) in
                self.feedExpanded = false
                self.addSpeechEventCell.removeFromSuperview()
                self.resetAllFeedCardsAnimation()
            }
        } else {
            addButton.setImage(UIImage(named:"addIcon"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.addEventCell.frame = CGRect(x: 500, y: 100, width: self.view.frame.width - 40, height: self.view.frame.width - 100)
            }) { (done) in
                self.feedExpanded = false
                self.addEventCell.removeFromSuperview()
                self.resetAllFeedCardsAnimation()
            }
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
