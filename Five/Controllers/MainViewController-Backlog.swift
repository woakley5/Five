//
//  MainViewController-Backlog.swift
//  Five
//
//  Created by Will Oakley on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    
    func initBacklogCells() {
        let backlogColors = [Constants.workOrange, Constants.personalBlue, Constants.financeGreen, Constants.homeRed]
        let backlogTitles = ["Work", "Personal", "Finance", "Home"]
        
        let tags: [TaskTag] = [.work, .personal, .finance, .home]
        for i in 0..<4 {
            let width = Int(view.frame.width - 40)
            let cell = BacklogCellView(frame: CGRect(x: 20, y: 100 + (100 * i), width: width, height: 60), color: backlogColors[i]!, tag: tags[i])
            cell.headerLabel.text = backlogTitles[i]
            cell.header.tag = i + 50
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedBacklogCell(sender:)))
            cell.header.addGestureRecognizer(tapGestureRecognizer)
            view.addSubview(cell)
            backlogCards.append(cell)
            cell.animate()
        }
        
        var zVal = backgroundGradientView.layer.zPosition + 5
        for card in backlogCards {
            card.layer.zPosition = CGFloat(zVal)
            zVal = zVal - 1
        }
    }
    
    func dismissBacklogCells(completion: @escaping () -> Void) {
        if backlogExpanded {
            contractBacklog()
        }
        for card in backlogCards {
            UIView.animate(withDuration: 0.5, animations: {
                card.frame = CGRect(x: card.frame.minX - 500, y: card.frame.maxY, width: card.frame.width, height: card.frame.height)
            }) { (done) in
                card.removeFromSuperview()
                self.backlogCards.removeFirst()
            }
        }
        completion()
    }
    
    @objc func tappedBacklogCell(sender: UITapGestureRecognizer) {
        print(sender.view!.tag)
        if !backlogExpanded {
            expandAndShowBacklogCell(cellIndex: sender.view!.tag - 50)
        } else {
            contractBacklog()
        }
    }
    
    func contractBacklog() {
        backlogExpanded = false
        backlogAddEventShowing = false
        for (i, card) in backlogCards.enumerated() {
            card.isUserInteractionEnabled = true
            card.contract()
            let width = Int(view.frame.width - 40)
            UIView.animate(withDuration: 0.5) {
                card.frame = CGRect(x: 20, y: 100 + (100 * i), width: width, height: 60)
            }
        }
    }
    
    func backlogShowAddEvent(speech: Bool) {
        if backlogExpanded {
            contractBacklog()
        }
        
        backlogAddEventShowing = true
        for i in (0..<backlogCards.count) {
            let yVal = (20 * i) + 400
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            let deadlineTime = DispatchTime.now()
            backlogCards[i].isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.backlogCards[i].animate(toFrame: frame) {
                    print("Done animating expand")
                }
            }
        }
        if speech {
            addSpeechButton.setImage(UIImage(named:"cancelIcon"), for: .normal)
            addSpeechEventCell = AddSpeechEventCellView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.width - 100), controller: self)
            view.addSubview(addSpeechEventCell)
            addSpeechEventCell.doneButton.addTarget(self, action: #selector(saveSpeechEventBacklog), for: .touchUpInside)
            addSpeechEventCell.animate()
        } else {
            addButton.setImage(UIImage(named:"cancelIcon"), for: .normal)
            addEventCell = AddEventCellView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.width - 100), controller: self)
            view.addSubview(addEventCell)
            addEventCell.animate()
            addEventCell.doneButton.addTarget(self, action: #selector(backlogSaveEvent), for: .touchUpInside)
        }
        
    }
    
    @objc func saveSpeechEventBacklog() {
        //TODO: get data from addEventCell and save to Task and TaskList
        if let text = addSpeechEventCell.textView.text {
            parseSpeech(data: text)
            dismissBacklogAddView(speech: true)
            for card in backlogCards {
                card.reload()
            }
        } else {
            print("Missing field")
        }
    }
    
    @objc func backlogSaveEvent() {
        //TODO: get data from addEventCell and save to Task and TaskList
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
            
            for card in backlogCards {
                card.reload()
            }
            dismissBacklogAddView(speech: false)

        } else {
            print("Missing field")
        }
    }
    
    func dismissBacklogAddView(speech: Bool) {
        if speech {
            addSpeechButton.setImage(UIImage(named:"microphone"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.addSpeechEventCell.frame = CGRect(x: 500, y: 100, width: self.view.frame.width - 40, height: self.view.frame.width - 100)
            }) { (done) in
                self.backlogAddEventShowing = false
                self.addSpeechEventCell.removeFromSuperview()
                self.contractBacklog()
            }
        } else {
            addButton.setImage(UIImage(named:"addIcon"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.addEventCell.frame = CGRect(x: 500, y: 100, width: self.view.frame.width - 40, height: self.view.frame.width - 100)
            }) { (done) in
                self.backlogAddEventShowing = false
                self.addEventCell.removeFromSuperview()
                self.contractBacklog()
            }
        }
        
    }
    
    func expandAndShowBacklogCell(cellIndex: Int) {
        backlogExpanded = true
        var offset = 0
        for i in (0..<backlogCards.count) {
            if i == cellIndex {
                offset = 1
                UIView.animate(withDuration: 0.5) {
                    self.backlogCards[i].frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 300)
                }
                backlogCards[i].expand()
            } else {
                let yVal = (20 * (i - offset)) + 400
                let width = Int(self.view.frame.width - 40)
                let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
                let deadlineTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.backlogCards[i].animate(toFrame: frame) {
                        print("Done animating expand")
                    }
                }
            }
        }
    }
    
    func dismissBacklog(completion: @escaping () -> Void) {
        if backlogAddEventShowing {
            dismissBacklogAddView(speech: false)
        }
        dismissBacklogCells {
            completion()
        }
    }
    
}
