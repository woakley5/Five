//
//  MainViewController-Completed.swift
//  Five
//
//  Created by Will Oakley on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    
    func initCompletedCells() {
        let CompletedColors = [Constants.workOrange, Constants.personalBlue, Constants.financeGreen, Constants.homeRed]
        let CompletedTitles = ["Work", "Personal", "Finance", "Home"]
        
        let tags: [TaskTag] = [.personal, .work, .finance, .home]
        for i in 0..<4 {
            let width = Int(view.frame.width - 40)
            let cell = CompletedCellView(frame: CGRect(x: 20, y: 100 + (100 * i), width: width, height: 60), color: CompletedColors[i]!, tag: tags[i])
            cell.headerLabel.text = CompletedTitles[i]
            cell.header.tag = i + 50
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedCompletedCell(sender:)))
            cell.header.addGestureRecognizer(tapGestureRecognizer)
            view.addSubview(cell)
            completedCards.append(cell)
            cell.animate()
        }
        
        var zVal = backgroundGradientView.layer.zPosition + 5
        for card in completedCards {
            card.layer.zPosition = CGFloat(zVal)
            zVal = zVal - 1
        }
    }
    
    func dismissCompletedCells(completion: @escaping () -> Void) {
        if completedExpanded {
            contractCompleted()
        }
        for card in completedCards {
            UIView.animate(withDuration: 0.5, animations: {
                card.frame = CGRect(x: card.frame.minX, y: card.frame.maxY + 900, width: card.frame.width, height: card.frame.height)
            }) { (done) in
                card.removeFromSuperview()
                self.completedCards.removeFirst()
            }
        }
        completion()
    }
    
    @objc func tappedCompletedCell(sender: UITapGestureRecognizer) {
        print(sender.view!.tag)
        if !completedExpanded {
            expandAndShowCompletedCell(cellIndex: sender.view!.tag - 50)
        } else {
            contractCompleted()
        }
    }
    
    func contractCompleted() {
        completedExpanded = false
        for (i, card) in completedCards.enumerated() {
            card.contract()
            let width = Int(view.frame.width - 40)
            UIView.animate(withDuration: 0.5) {
                card.frame = CGRect(x: 20, y: 100 + (100 * i), width: width, height: 60)
            }
        }
    }
    
    func expandAndShowCompletedCell(cellIndex: Int) {
        completedExpanded = true
        var offset = 0
        for i in (0..<completedCards.count) {
            if i == cellIndex {
                offset = 1
                UIView.animate(withDuration: 0.5) {
                    self.completedCards[i].frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 300)
                }
                completedCards[i].expand()
            } else {
                let yVal = (20 * (i - offset)) + 400
                let width = Int(self.view.frame.width - 40)
                let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
                let deadlineTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.completedCards[i].animate(toFrame: frame) {
                        print("Done animating expand")
                    }
                }
            }
        }
    }
    
    func dismissCompleted(completion: @escaping () -> Void) {
        dismissCompletedCells {
            completion()
        }
    }
}
