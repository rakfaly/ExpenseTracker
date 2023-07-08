//
//  StartPage.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 27/06/2023.
//
import CoreData
import SwiftUI

struct StartPageView: View {
    //MARK: - Properties
    @AppStorage("session") private var session: String?
    
    //MARK: - body
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    //MARK: - Wallet Image
                    Circle()
                        .fill(Color.buttonPurple)
                        .overlay {
                            Image("portefeuille")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 400)
                        }
                    
                    //MARK: - Decription
                    VStack(alignment: .center) {
                        Text("Take Control of ")
                        Text("Your Finance")
                    }
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .padding(.top, 40)
                    .padding(.bottom)
                    
                    Text("Expense tracker app empowers you to understand your spending habits and take control of your finances. Stay on top of your expenses effortlessly and make informed decisions about your money.")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .foregroundColor(.backgroundSecondary)
                    
                    Spacer()
                    
                    //MARK: - Start Button
                    NavigationLink {
                        if session != nil {
                            withAnimation {
                                AppTabView().navigationBarBackButtonHidden(true)
                            }
                        } else {
                            withAnimation {
                                AddProfile().navigationBarBackButtonHidden(true)
                            }
                        }
                    } label: {
                        Text("Let's Start")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 20, leading: 45, bottom: 20, trailing: 45))
                            .background(Color.buttonPurple)
                            .cornerRadius(10)
                            .shadow(color: .white, radius: 2)
                    }
                    .padding(.bottom)
                } //: VStack
                .padding(.horizontal, 30)
            } //: ZStack
        } //: Navigation
    } //: body
}

struct StartPage_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
            .preferredColorScheme(.dark)
    }
}
