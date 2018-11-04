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

struct PINK_GRADIENT: GRADIENT {
    var colors = [UIColor("#FDA0A7"), UIColor("#FB76A4")]
    var locations: [CGFloat] = [0.2, 0.8]
    var direction = GradientView.Direction.horizontal
}

struct BLUE_GRADIENT: GRADIENT {
    var colors = [UIColor("#5CCAE5"), UIColor("#0CCEC2")]
    var locations: [CGFloat] = [0.2, 0.8]
    var direction = GradientView.Direction.horizontal
}

