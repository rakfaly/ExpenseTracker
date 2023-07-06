//
//  TabViewExample.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 27/06/2023.
//

import SwiftUI

struct TabViewExample: View {
    var body: some View {
        TabView {
            Group {
                NavigationStack {
                    HomeView()
                    //                    .navigationDestination(for: Account.self) { account in
                    //                        AccountView(account: account)
                    //                    }
                        .navigationTitle("Home")
//                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            Image(systemName: "bell.badge.fill")
            //                    .renderingMode(.original)
                                .symbolRenderingMode(.hierarchical)
                        }
                        .toolbarBackground(Color.backgroundSecondary, for: .navigationBar)

                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
                
                Text("Explore")
                    .tabItem {
                        Label("Overview", systemImage: "chart.bar.xaxis")
                    }
                    .tag(2)
                Text("Search")
                    .tabItem {
                        Image(systemName: "plus.circle")
                            .font(.largeTitle)
                    }
                    .tag(3)
                Text("Notification")
                    .tabItem {
                        Label("Wallet", systemImage: "wallet")
                    }
                    .tag(4)
                Text("Settings")
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(5)
            }
            .toolbarBackground(Color.backgroundSecondary, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
//            .toolbarColorScheme(.light, for: .tabBar)
        } //: Tabview
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .systemIndigo
        }
    }
}

struct TabViewExample_Previews: PreviewProvider {
    static var previews: some View {
        TabViewExample()
    }
}
