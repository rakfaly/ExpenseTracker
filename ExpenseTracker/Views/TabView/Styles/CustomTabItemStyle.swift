//
//  CustomTabItemStyle.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 06/07/2023.
//

import SwiftUI
import TabBar

struct CustomTabItemStyle: TabItemStyle {
    
    func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 40.0, height: 40.0)
            }
            
            Image(systemName: icon)
//                .foregroundColor(isSelected ? .white : Color("color.tab.item.foreground"))
                .foregroundColor(isSelected ? .white : .secondary)
                .frame(width: 32.0, height: 32.0)
        }
        .padding(.vertical, 8.0)
    }
}

