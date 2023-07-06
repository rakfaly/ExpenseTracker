//
//  ColorEnum.swift
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
    case mint
    case primary
    case brown
    case secondary
    
    var color: Color {
        switch self {
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .blue:
            return Color.blue
        case .purple:
            return Color.purple
        case .pink:
            return Color.pink
        case .teal:
            return Color.teal
        case .indigo:
            return Color.indigo
        case .gray:
            return Color.gray
        case .black:
            return Color.black
        case .cyan:
            return Color.cyan
        case .mint:
            return Color.mint
        case .primary:
            return Color.primary
        case .brown:
            return Color.brown
        case .secondary:
            return Color.secondary
        }
    }
}
