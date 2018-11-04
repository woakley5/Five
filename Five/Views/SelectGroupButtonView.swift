//
//  SelectGroupButtonView.swift
//  Five
//
//  Created by Daniel Andrews on 11/3/18.
//  Copyright © 2018 Daniel Andrews. All rights reserved.
//

import UIKit

class SelectGroupButtonView: UIView {
    
    var ringView: UIView!
    var color: UIColor!
    var label: UILabel!
    var group: String!
    var buttonTag: TaskTag!
    
    var tagView: UIView!
    var tagButton: UIButton!
    
    var delegate: GroupButtonProtocol?
    
    init(frame: CGRect, color: UIColor, group: String, buttonTag: TaskTag) {
        super.init(frame: frame)
        
        self.color = color
        self.group = group
        self.buttonTag = buttonTag
        
        backgroundColor = rgbaToUIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        setupTagView()
        setupBorder()
        setupRing()
        setupLabel()
    }
    
    func setupTagView () {
        tagView = UIView(frame: CGRect(x: 10, y: 0, width: 70, height: 50))
        tagView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(groupSelected))
        tagView.addGestureRecognizer(tapGestureRecognizer)
        addSubview(tagView)
    }
    
    func setupBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
    }
    
    func setupRing() {
        ringView = UIView(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        ringView.layer.borderWidth = 4
        ringView.layer.cornerRadius = 10
        ringView.layer.borderColor = color.cgColor
        tagView.addSubview(ringView)
    }
    
    func setupLabel() {
        label = UILabel(frame: CGRect(x: ringView.frame.maxX + 15, y: 10, width: 70, height: 20))
        label.text = group
        label.textColor = .white
        label.font = label.font?.withSize(18)
        tagView.addSubview(label)
    }
    
    
    @objc func groupSelected() {
        delegate?.select(buttonTag: buttonTag)
    }
    
    func selectMe() {
        backgroundColor = backgroundColor?.withAlphaComponent(0.2)
        label.textColor = color
    }
    
    func unselectMe() {
        backgroundColor = backgroundColor?.withAlphaComponent(0)
        label.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
