//
//  SelectGroupContainerView.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Daniel Andrews. All rights reserved.
//

import UIKit

protocol GroupButtonProtocol {
    func select(buttonTag: TaskTag)
}

class SelectGroupContainerView: UIView, GroupButtonProtocol {
    
    var personal: SelectGroupButtonView!
    var home: SelectGroupButtonView!
    var work: SelectGroupButtonView!
    var finance: SelectGroupButtonView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGroups()
    }
    
    func createGroups() {
        personal = SelectGroupButtonView(frame: CGRect(x: 10, y: 20, width: 130, height: 40), color: Constants.personalBlue, group: "Personal", buttonTag: .personal)
        work = SelectGroupButtonView(frame: CGRect(x: personal.frame.maxX + 20, y: personal.frame.minY, width: 130, height: 40), color: Constants.workOrange, group: "Work", buttonTag: .work)
        finance = SelectGroupButtonView(frame: CGRect(x: personal.frame.minX, y: personal.frame.maxY + 20, width: 130, height: 40), color: Constants.financeGreen, group: "Finance", buttonTag: .finance)
        home = SelectGroupButtonView(frame: CGRect(x: work.frame.minX, y: finance.frame.minY, width: 130, height: 40), color: Constants.homeRed, group: "Home", buttonTag: .home)
        
        personal.delegate = self
        work.delegate = self
        finance.delegate = self
        home.delegate = self
        
        addSubview(personal)
        addSubview(work)
        addSubview(finance)
        addSubview(home)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectGroupContainerView {
    func select(buttonTag: TaskTag) {
        if buttonTag == .finance {
            finance.selectMe()
            work.unselectMe()
            home.unselectMe()
            personal.unselectMe()
        } else if buttonTag == .work {
            finance.unselectMe()
            work.selectMe()
            home.unselectMe()
            personal.unselectMe()
        } else if buttonTag == .home {
            finance.unselectMe()
            work.unselectMe()
            home.selectMe()
            personal.unselectMe()
        } else if buttonTag == .personal {
            finance.unselectMe()
            work.unselectMe()
            home.unselectMe()
            personal.selectMe()
        }
    }
}
