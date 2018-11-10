//
//  TaskCellView.swift
//  
//
//  Created by Will Oakley on 11/3/18.
//

import UIKit
import GradientView
import UIColor_Hex_Swift

class TaskCellView: SpringView {
    
    var background: GradientView!
    var taskTitleLabel: UILabel!
    var taskSubtitleLabel: UILabel!
    var gradient: GRADIENT!
    var originalFrame: CGRect!
    var completeButton: UIButton!
    var task: Task!

    init(frame: CGRect, gradient: GRADIENT, task: Task) {
        super.init(frame: frame)
        self.task = task
        originalFrame = frame
        self.gradient = gradient
        initBackground()
        initLayer()
        initUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayer() {
        background.layer.cornerRadius = 20
        background.clipsToBounds = true
        background.alpha = 0.85
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 6)
        self.layer.shadowOpacity = 0.5
    }
    
    private func initBackground() {
        background = GradientView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        background.colors = gradient!.colors
        background.locations = gradient!.locations
        background.direction = gradient!.direction
        addSubview(background)
    }
    
    private func initUIElements() {
        taskTitleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: background.frame.width - 45, height: 30))
        taskTitleLabel.font = UIFont(name: "Quicksand-Bold", size: 18)
        taskTitleLabel.textColor = .white
        taskTitleLabel.text = task.text
        background.addSubview(taskTitleLabel)
        
        completeButton = UIButton(frame: CGRect(x: frame.width - 10 - 35, y: frame.height/2 - 35/2, width: 35, height: 35))
        completeButton.setImage(UIImage(named: "checkIcon"), for: .normal)
        //doneButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        addSubview(completeButton)
        
        if let dueDate = task.dueDate {
            let date = dueDate.addingTimeInterval(60.0 * 60.0 * 23.0 + 60.0 * 59.0)
            guard let daysLeft = Calendar.current.dateComponents([.day], from: task.createDate, to: date).day else {
                print ("failed to get days left")
                return
            }
            
            taskSubtitleLabel = UILabel(frame: CGRect(x: 30, y: 30, width: background.frame.width - 30, height: 40))
            taskSubtitleLabel.font = UIFont(name: "Quicksand-Medium", size: 14)
            taskSubtitleLabel.textColor = .white
            
            if daysLeft == 0 {
                taskSubtitleLabel.text = "> Due today"
            } else if daysLeft > 0 {
                taskSubtitleLabel.text = "> Due in \(daysLeft) day\(daysLeft > 1 ? "s" : "")"
            } else {
                taskSubtitleLabel.text = "> Was due \(-daysLeft) day\(daysLeft > 1 ? "s" : "") ago"
            }
            
            background.addSubview(taskSubtitleLabel)
        }
    }
    

    func animate(toFrame: CGRect, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = toFrame
            self.background.frame = CGRect(x: 0, y: 0, width: toFrame.width, height: toFrame.height)
        }) { (done) in
            completion()
        }
    }
}
