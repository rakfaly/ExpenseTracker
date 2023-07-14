//
//  Tab.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 06/07/2023.
//

import Foundation
import TabBar


enum Tabs: Tabbable {
    case home, overview, add, wallet, profile
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .overview:
            return "chart.bar.xaxis"
        case .add:
            return "plus.circle.fill"
        case .wallet:
            return "list.bullet.rectangle.fill"
        case .profile:
            return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .overview:
            return "Overview"
        case .add:
            return "Add"
        case .wallet:
            return "Wallet"
        case .profile:
            return "Profile"
        }
    }
    
}
