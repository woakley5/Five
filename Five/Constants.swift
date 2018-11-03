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

class Constants {
    
    
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
    var colors = [UIColor("#A7D8FF"), UIColor("#808AFF")]
    var locations: [CGFloat] = [0.2, 0.8]
    var direction = GradientView.Direction.horizontal
}

