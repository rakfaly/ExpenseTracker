//
//  CustomTabBar.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 06/07/2023.
//

import TabBar
import SwiftUI

struct CustomTabBar: View {
    @State private var selection: Tabs = .home
    @State private var visibility: TabBarVisibility = .visible
    
    var body: some View {
        TabBar(selection: $selection, visibility: $visibility) {
            HomeView()
                .tabItem(for: Tabs.home)
            
            OverviewView(isAddView: false)
                .tabItem(for: Tabs.overview)
            
            OverviewView(isAddView: true)
                .tabItem(for: Tabs.add)
            
            AccountListView()
                .tabItem(for: Tabs.wallet)
            
            ProfileView()
                .tabItem(for: Tabs.profile)
        } //: TabBar
        .tabBar(style: CustomTabBarStyle())
        .tabItem(style: CustomTabItemStyle())
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}
