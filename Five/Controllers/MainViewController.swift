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
    
    enum STATES {
        case backlog
        case feed
        case completed
    }
    
    var currentState: STATES!
    
    //MAIN UI InstanceVariables
    var titleLabel: LTMorphingLabel!
    var addButton: UIButton!
    var backgroundGradientView: GradientView!
    var backgroundGradient: GRADIENT!
    var mainCardFrame: CGRect!
    var backlogButton: UIButton!
    var feedButton: UIButton!
    var completedButton: UIButton!
    
    //FEED INSTANCE VARIABLES
    var feedCards: [TaskCellView] = []
    var feedExpanded = false
    
    //BACKLOG INSTANCE VARIABLES
    
    //COMPLETED INSTANCE VARIABLES

    override func viewDidLoad() {
        super.viewDidLoad()
        mainCardFrame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: view.frame.width - 80)
        initCommonUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateLabel(withText: "five")
        switchStateTo(.feed)
    }
    
    func animateLabel(withText: String) {
        titleLabel.text = withText
    }
    
    func initCommonUI() {
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
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        view.addSubview(addButton)
        initBottomButtons()
    }
    
    func initBottomButtons() {
        let yVal = view.frame.height * 0.9
        let dim: CGFloat = 50
        let widthBase = view.frame.width
        
        backlogButton = UIButton(frame: CGRect(x: widthBase * 0.25 - 20, y: yVal, width: dim, height: dim))
        backlogButton.setImage(UIImage(named: "timerIcon"), for: .normal)
        backlogButton.addTarget(self, action: #selector(tappedBacklog), for: .touchUpInside)
        view.addSubview(backlogButton)
        
        feedButton = UIButton(frame: CGRect(x: widthBase * 0.5 - 20, y: yVal, width: dim, height: dim))
        feedButton.setImage(UIImage(named: "checklistIcon"), for: .normal)
        feedButton.addTarget(self, action: #selector(tappedFeed), for: .touchUpInside)
        view.addSubview(feedButton)
        
        completedButton = UIButton(frame: CGRect(x: widthBase * 0.75 - 20, y: yVal, width: dim, height: dim))
        completedButton.setImage(UIImage(named: "clipboardIcon"), for: .normal)
        completedButton.addTarget(self, action: #selector(tappedCompleted), for: .touchUpInside)
        view.addSubview(completedButton)
    }
    
    @objc func tappedBacklog() {
        switchStateTo(.backlog)
    }
    
    @objc func tappedFeed() {
        switchStateTo(.feed)
    }
    
    @objc func tappedCompleted() {
        switchStateTo(.completed)
    }
    
    func switchStateTo(_ state: STATES) {
        currentState = state
        if state == .backlog {
            
        } else if state == .feed {
            print("Showing feed cells")
            initFeedCells()
            
        } else if state == .completed {
            hideFeedCells()
        }
    }
    
    @objc func tappedAddButton() {
        print("Tapped add")
    }

}

