//
//  ViewController.swift
//  Five
//
//  Created by Will Oakley on 11/2/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class MainViewController: UIViewController {
    
    var titleLabel: LTMorphingLabel!
    var addButton: UIButton!
    var cards: [TaskCellView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = UIColor("#242C49")
        titleLabel = LTMorphingLabel(frame: CGRect(x: 20, y: 10, width: 200, height: 90))
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.morphingEffect = .evaporate
        titleLabel.morphingDuration = 1.5
        titleLabel.font = UIFont(name: "Avenir", size: 36)
        view.addSubview(titleLabel)
        
        addButton = UIButton(frame: CGRect(x: view.frame.width - 60, y: 35, width: 40, height: 40))
        addButton.setImage(UIImage(named: "addIcon"), for: .normal)
        addButton.addTarget(self, action: #selector(tappedAdd), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    func initCells() {
        for x in 0..<5 {
            let yVal = (100 * x) + 100
            let width = Int(self.view.frame.width - 40)
            let card = TaskCellView(frame: CGRect(x: 20, y: yVal, width: width, height: 80))
            cards.append(card)
            card.animation = "slideUp"
            card.duration = 1.0
        }
        
        for (i, card) in cards.enumerated() {
            let deadlineTime = DispatchTime.now() + .milliseconds(200 * i)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.view.addSubview(card)
                card.animate()
            }
        }
    }
    
    @objc func tappedAdd() {
        print("yay")
    }


}

