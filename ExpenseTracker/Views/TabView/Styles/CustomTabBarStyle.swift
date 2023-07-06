//
//  CustomTabBarStyle.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 06/07/2023.
//

import TabBar
import SwiftUI

struct CustomTabBarStyle: TabBarStyle {
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        itemsContainer()
            .background(Color.backgroundMain)
            .cornerRadius(25.0)
            .frame(height: 50.0)
            .padding()
//            .padding(.horizontal, 64.0)
//            .padding(.bottom, 16.0 + geometry.safeAreaInsets.bottom)
    }
}

