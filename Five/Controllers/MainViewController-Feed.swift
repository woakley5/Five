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
        let gradients: [GRADIENT] = [BLUE_GRADIENT(), PINK_GRADIENT()]
        for i in 0..<5 {
            let gradient: GRADIENT
            if i % 2 == 0 {
                gradient = gradients[0]
            } else {
                gradient = gradients[1]
            }
            let yVal = (100 * i) + 100
            let width = Int(self.view.frame.width - 40)
            let card = TaskCellView(frame: CGRect(x: 20, y: yVal, width: width, height: 80), gradient: gradient)
            feedCards.append(card)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedFeedCell(sender:)))
            card.addGestureRecognizer(tapGestureRecognizer)
            card.animation = "slideUp"
            card.duration = 1.0
            card.tag = i
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
                card.animate()
            }
        }
    }

    func hideFeedCells() {
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
    }
    
    func expandFirstFeedCellAnimation() {
        feedExpanded = true
        for i in (1..<5) {
            let yVal = (20 * i) + 400
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            let deadlineTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.feedCards[i].animate(toFrame: frame) {
                    print("Done animating expand")
                }
            }
        }
        let deadlineTime = DispatchTime.now() + .milliseconds(200)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.feedCards[0].animate(toFrame: self.mainCardFrame) {
                print("done animating expand first")
            }
        }
    }
    
    func resetAllFeedCardsAnimation() {
        feedExpanded = false
        for (i, card) in feedCards.enumerated() {
            let yVal = (100 * i) + 100
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            card.animate(toFrame: frame) {
                print("Done animating reset")
            }
        }
    }
    
    @objc func tappedFeedCell(sender: UITapGestureRecognizer) {
        let view = sender.view as! TaskCellView
        let tag = view.tag
        if tag == 0 {
            if feedExpanded {
                resetAllFeedCardsAnimation()
            } else {
                expandFirstFeedCellAnimation()
            }
        }
    }
}
