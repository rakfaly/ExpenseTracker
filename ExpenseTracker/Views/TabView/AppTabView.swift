//
//  AppTabView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 27/06/2023.
//

import SwiftUI

struct AppTabView: View {
    //MARK: - Properties
    @State private var tabSelection: Tab = .home
    
    enum Tab {
        case home, overview, add, wallet, profile
    }
    
    //MARK: - body
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                NavigationStack {
                    HomeView()
                        .navigationTitle("Home")
                        .navigationBarTitleDisplayMode(.inline)
                    
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
                
                NavigationStack {
                    OverviewView(isAddView: false)
                        .navigationTitle("Overview")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Label("Overview", systemImage: "chart.bar.xaxis")
                }
                .tag(Tab.overview)
                
                NavigationStack {
                    OverviewView(isAddView: true)
                        .navigationTitle("Add Transactions")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                }
                .tag(Tab.add)
                
                NavigationStack {
                    AccountListView()
                }
                .tabItem {
                    Label("Wallet", systemImage: "list.bullet.rectangle.fill")
                }
                .tag(Tab.wallet)
                
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
            } //: TabView
        } //: ZStack
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color.backgroundMain)
        }
    } //:body
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .preferredColorScheme(.dark)
    }
}
