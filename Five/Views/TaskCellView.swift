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


    init(frame: CGRect, gradient: GRADIENT) {
        super.init(frame: frame)
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
        taskTitleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: background.frame.width/2, height: 30))
        taskTitleLabel.font = UIFont(name: "Quicksand-Bold", size: 18)
        taskTitleLabel.textColor = .white
        taskTitleLabel.text = "Event!"
        background.addSubview(taskTitleLabel)
        
        taskSubtitleLabel = UILabel(frame: CGRect(x: 30, y: 30, width: background.frame.width - 30, height: 40))
        taskSubtitleLabel.font = UIFont(name: "Quicksand-Medium", size: 14)
        taskSubtitleLabel.textColor = .white
        taskSubtitleLabel.text = "> You have 3 days remaining"
        background.addSubview(taskSubtitleLabel)
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
