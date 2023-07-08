//
//  CustomTabView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 06/07/2023.
//

import SwiftUI

struct CustomTabView: View {
    @State private var tabSelection: Tabs = .home
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $tabSelection) {
                    NavigationStack {
                        HomeView()
                            .navigationTitle("Home")
                            .navigationBarTitleDisplayMode(.inline)
                        
                    } // Navigation
                    .tag(Tabs.home)
                    
                    NavigationStack {
                        OverviewView(isAddView: false)
                            .navigationTitle("Overview")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    .tag(Tabs.overview)
                    
                    NavigationStack {
                        OverviewView(isAddView: true)
                            .navigationTitle("Add Transactions")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    
                    NavigationStack {
                        AccountListView()
                    }
                    .tag(Tabs.wallet)
                    
                    NavigationStack {
                        ProfileView()
                    }
                    .tag(Tabs.profile)
                } //: TabView
                .animation(.easeInOut(duration: 1), value: tabSelection)
                .transition(.slide)
            } //: VStack
            
            VStack {
                Spacer()
                ManualCustomTabBar(selectedTab: $tabSelection)
            }
        } //: ZStack
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
            .preferredColorScheme(.dark)
    }
}
