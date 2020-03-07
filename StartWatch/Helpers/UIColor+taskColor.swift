//
//  UIColor+taskColor.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation
import UIKit

enum TaskColor: Int16 {
    case black = 0
    case red = 1
    case orange = 2
    case yellow = 3
    case green = 4
    case blue = 5
    case indigo = 6
    case lavender = 7
    case pink = 8
    case white = 9
    case gray = 10
    case brown = 11
}

let TASK_COLOR_MIN: Int16 = 0
let TASK_COLOR_MAX: Int16 = 11

extension UIColor {
    func taskColor(_ taskColor: TaskColor) -> UIColor {
        let color: UIColor
        
        switch taskColor {
        case .black:
            color = UIColor.black
        case .red:
            color = UIColor.systemRed
        case .orange:
            color = UIColor.systemOrange
        case .yellow:
            color = UIColor.systemYellow
        case .green:
            color = UIColor.systemGreen
        case .blue:
            color = UIColor.systemBlue
        case .indigo:
            color = UIColor.systemIndigo
        case .lavender:
            color = UIColor.systemPurple
        case .pink:
            color = UIColor.systemPink
        case .white:
            color = UIColor.white
        case .gray:
            color = UIColor.systemGray
        case .brown:
            color = UIColor.brown
        }
        
        return color
    }
}
