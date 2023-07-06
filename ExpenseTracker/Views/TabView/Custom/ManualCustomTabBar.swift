//
//  CustomTabItem.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 06/07/2023.
//

import SwiftUI

struct ManualCustomTabBar: View {
    @Binding var selectedTab: Tabs
    var body: some View {
        HStack(spacing: 30) {
            SingleItem(imageName: "house.fill", text: "Home")
                .foregroundColor(selectedTab == .home ? Color.buttonPurple : .white)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        selectedTab = .home
                    }
                }
            
            SingleItem(imageName: "chart.bar.xaxis", text: "Overview")
                .foregroundColor(selectedTab == .overview ? Color.buttonPurple : .white)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        selectedTab = .overview
                    }
                }
            
            NavigationLink {
                OverviewView(isAddView: true)
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 60)
                        .padding(.bottom, 40)
                        .foregroundColor(.white)
                        .blur(radius: 2)
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 57))
                        .foregroundColor(Color.buttonPurple)
                        .shadow(color: Color.secondary, radius: 7, x: 0, y: 3)
                        .padding(.top, -40)
                }
            }
            
            SingleItem(imageName: "list.bullet.rectangle.fill", text: "Wallet")
                .foregroundColor(selectedTab == .wallet ? Color.buttonPurple : .white)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        selectedTab = .wallet
                    }
                }
            
            SingleItem(imageName: "person.fill", text: "Profile")
                .foregroundColor(selectedTab == .profile ? Color.buttonPurple : .white)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        selectedTab = .profile
                    }
                }
        } //: HStack
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundMain)
    }
}

struct ManualCustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ManualCustomTabBar(selectedTab: .constant(.home))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
