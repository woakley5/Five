//
//  ViewController.swift
//  Five
//
//  Created by Will Oakley on 11/2/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import GradientView

class MainViewController: UIViewController {
    
    var titleLabel: LTMorphingLabel!
    var addButton: UIButton!
    var cards: [TaskCellView] = []
    var backgroundGradientView: GradientView!
    var backgroundGradient: GRADIENT!
    
    var mainCardFrame: CGRect!
    
    var expanded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        mainCardFrame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.width - 80)
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateLabel()
        initCells()
    }
    
    func animateLabel() {
        titleLabel.text = "five"
    }
    
    func initUI() {
        backgroundGradient = BACKGROUND_GRADIENT()
        backgroundGradientView = GradientView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundGradientView.colors = backgroundGradient!.colors
        backgroundGradientView.locations = backgroundGradient!.locations
        backgroundGradientView.direction = backgroundGradient!.direction
        view.addSubview(backgroundGradientView)
        //view.backgroundColor = UIColor("#242C49")
        titleLabel = LTMorphingLabel(frame: CGRect(x: 20, y: 10, width: 200, height: 90))
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.morphingEffect = .evaporate
        titleLabel.morphingDuration = 1.5
        titleLabel.font = UIFont(name: "Quicksand-Bold", size: 36)
        view.addSubview(titleLabel)
        
        addButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: 35, width: 40, height: 40))
        addButton.setImage(UIImage(named: "addIcon"), for: .normal)
        addButton.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    func initCells() {
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
            cards.append(card)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedCell(sender:)))
            card.addGestureRecognizer(tapGestureRecognizer)
            card.animation = "slideUp"
            card.duration = 1.0
            card.tag = i
        }
        
        var zVal = backgroundGradientView.layer.zPosition + 5
        for card in cards {
            card.layer.zPosition = CGFloat(zVal)
            zVal = zVal - 1
        }
        
        for (i, card) in cards.enumerated() {
            let deadlineTime = DispatchTime.now() + .milliseconds(200 * i)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.view.addSubview(card)
                card.animate()
            }
        }
    }
    
    func expandFirstCellAnimation() {
        expanded = true
        for i in (1..<5) {
            let yVal = (20 * i) + 400
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            let deadlineTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.cards[i].animate(toFrame: frame)
            }
        }
        let deadlineTime = DispatchTime.now() + .milliseconds(200)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.cards[0].animate(toFrame: self.mainCardFrame)
        }
    }
    
    func resetAllCardsAnimation() {
        expanded = false
        for (i, card) in cards.enumerated() {
            let yVal = (100 * i) + 100
            let width = Int(self.view.frame.width - 40)
            let frame = CGRect(x: 20, y: yVal, width: width, height: 80)
            card.animate(toFrame: frame)
        }
    }
    
    @objc func tappedCell(sender: UITapGestureRecognizer) {
        let view = sender.view as! TaskCellView
        let tag = view.tag
        if tag == 0 {
            if expanded {
                resetAllCardsAnimation()
            } else {
                expandFirstCellAnimation()
            }
        }
    }
    
    @objc func tappedAdd() {
        resetAllCardsAnimation()
    }


}

