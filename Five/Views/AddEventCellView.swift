//
//  AddEventCellView.swift
//  Five
//
//  Created by Will Oakley on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit
import GradientView
import UIColor_Hex_Swift
import SkyFloatingLabelTextField

class AddEventCellView: SpringView {
    
    var titleLabel: UILabel!
    var nameField: SkyFloatingLabelTextField!
    var doneButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        animation = "slideLeft"
        initLayer()
        initUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayer() {
        backgroundColor = UIColor("#392C79")
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 6)
        self.layer.shadowOpacity = 0.5
    }
    
    private func initUIElements() {
        titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: frame.width - 40, height: 40))
        titleLabel.font = UIFont(name: "Quicksand-Bold", size: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = "New Task"
        addSubview(titleLabel)
        
        nameField = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 60, width: frame.width - 40, height: 50))
        nameField.placeholder = "Task Name"
        nameField.selectedTitle = "Task Name"
        nameField.selectedLineColor = .white
        nameField.selectedTitleColor = .white
        nameField.placeholderColor = .white
        nameField.textColor = .white
        nameField.tintColor = .white
        nameField.font = UIFont(name: "Quicksand-Medium", size: 16)
        nameField.titleFont = UIFont(name: "Quicksand-Medium", size: 14)!
        addSubview(nameField)
        
        doneButton = UIButton(frame: CGRect(x: frame.width - 20 - 35, y: frame.height - 20 - 35, width: 35, height: 35))
        doneButton.setImage(UIImage(named: "checkIcon"), for: .normal)
        //doneButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        addSubview(doneButton)
    }
    
    
}
