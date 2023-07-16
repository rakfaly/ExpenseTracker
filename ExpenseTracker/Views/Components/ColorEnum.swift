//
//  UIColorEnum.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 04/07/2023.
//

import Foundation
import SwiftUI

enum ColorEnum: CaseIterable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case teal
    case indigo
    case gray
    case black
    case cyan
    case lightGray
    case tertiaryLabel
    case brown
    case secondary
    
    var color: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .orange:
            return UIColor.orange
        case .yellow:
            return UIColor.yellow
        case .green:
            return UIColor.green
        case .blue:
            return UIColor.blue
        case .purple:
            return UIColor.purple
        case .pink:
            return UIColor.systemPink
        case .teal:
            return UIColor.systemTeal
        case .indigo:
            return UIColor.systemIndigo
        case .gray:
            return UIColor.gray
        case .black:
            return UIColor.black
        case .cyan:
            return UIColor.cyan
        case .lightGray:
            return UIColor.lightGray
        case .tertiaryLabel:
            return UIColor.tertiaryLabel
        case .brown:
            return UIColor.brown
        case .secondary:
            return UIColor.secondaryLabel
        }
    }
}
