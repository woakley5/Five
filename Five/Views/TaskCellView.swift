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

    override init(frame: CGRect) {
        super.init(frame: frame)
        initBackground()
        initLayer()
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
        background.colors = [UIColor("#AA7DE6"), UIColor("#81BFFF")]
        background.locations = [0.2, 0.8]
        background.direction = .horizontal
        addSubview(background)
    }
    
}
