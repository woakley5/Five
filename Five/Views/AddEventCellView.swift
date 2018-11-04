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
import DatePicker

class AddEventCellView: SpringView {
    
    var titleLabel: UILabel!
    var nameField: SkyFloatingLabelTextField!
    var doneButton: UIButton!
    var groups: SelectGroupContainerView!
    var calendarIcon: UIButton!
    var dateLabel: UILabel!
    
    var viewController: UIViewController!

    init(frame: CGRect, controller: UIViewController) {
        super.init(frame: frame)
        viewController = controller
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
        
        nameField = SkyFloatingLabelTextField(frame: CGRect(x: 20, y: 45, width: frame.width - 40, height: 50))
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
        
        doneButton = UIButton(frame: CGRect(x: frame.width - 20 - 35, y: 20, width: 35, height: 35))
        doneButton.setImage(UIImage(named: "checkIcon"), for: .normal)
        //doneButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        addSubview(doneButton)
        
        calendarIcon = UIButton(frame: CGRect(x:20, y: nameField.frame.minY + 65, width: 35, height:35))
        calendarIcon.setImage(UIImage(named: "calendarIcon"), for: .normal)
        calendarIcon.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        addSubview(calendarIcon)
        
        dateLabel = UILabel(frame:CGRect(x:calendarIcon.frame.minX + 40, y: nameField.frame.minY + 65, width: self.frame.width, height: 35))
        dateLabel.font = UIFont(name: "Quicksand-Bold", size: 14)
        dateLabel.textColor = .white
        dateLabel.text = "11/11/2018"
        addSubview(dateLabel)
        
        groups = SelectGroupContainerView(frame: CGRect(x: 20, y: calendarIcon.frame.maxY, width: frame.width - 40, height: 100))
        addSubview(groups)
    }
    
    
    @objc func openDatePicker(_ sender: UIButton) {
        //self.label.alpha = 1
        print("HERERERERERERE")
        let datePicker = DatePicker()
        datePicker.vc.view.layer.zPosition = 5000
        datePicker.vc.view.alpha = 0.9
        datePicker.colors(main: .black, background: .white, inactive: UIColor("#392C79"))
        datePicker.setup() { (selected, date) in
            if selected, let selectedDate = date {
                //print("\(selectedDate)")
                self.dateLabel.text = "\(selectedDate.month())/\(selectedDate.day())/\(selectedDate.year())"
            } else {
                self.dateLabel.text = "11/11/2018"
            }
        }
        
       // datePicker.displayPopOver(on: button, in: self)
        datePicker.display(in: viewController)
//        datePicker.vc.view.layer.zPosition = 1000
    }
    
}
