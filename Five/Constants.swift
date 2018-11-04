//
//  Constants.swift
//  Five
//
//  Created by Will Oakley on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift
import GradientView
import ChameleonFramework

class Constants {
    static let personalBlue: UIColor! = UIColor(hex: "39B8B5")
    static let workOrange: UIColor! = UIColor(hex: "F79F33")
    static let financeGreen: UIColor! = UIColor(hex: "A8E921")
    static let homeRed: UIColor! = UIColor(hex: "CB5D3E")
    
    static let backgroundPurple: UIColor! = UIColor(hex: "392C79")
}

protocol GRADIENT {
    var colors: [UIColor] { get }
    var locations: [CGFloat] { get }
    var direction: GradientView.Direction { get }
}

struct BACKGROUND_GRADIENT: GRADIENT {
    var colors = [UIColor("#392C79"), UIColor("#A7D8FF")]
    var locations: [CGFloat] = [0.5, 0.9]
    var direction = GradientView.Direction.vertical
}

struct WORK_ORANGE_GRADIENT: GRADIENT {
    var colors = [UIColor("#F79F33"), UIColor("#F79F33")]
    var locations: [CGFloat] = [0.2, 0.8]
    var direction = GradientView.Direction.horizontal
}

struct PERSONAL_BLUE_GRADIENT: GRADIENT {
    var colors = [UIColor("#39B8B5"), UIColor("#39B8B5")]
    var locations: [CGFloat] = [0.2, 0.8]
    var direction = GradientView.Direction.horizontal
}

struct FINANCE_GREEN_GRADIENT: GRADIENT {
    var colors = [UIColor("#A8E921"), UIColor("#A8E921")]
    var locations: [CGFloat] = [0.2, 0.8]
    var direction = GradientView.Direction.horizontal
}

struct HOME_RED_GRADIENT: GRADIENT {
    var colors = [UIColor("#CB5D3E"), UIColor("#CB5D3E")]
    var locations: [CGFloat] = [0.2, 0.8]
    var direction = GradientView.Direction.horizontal
}
