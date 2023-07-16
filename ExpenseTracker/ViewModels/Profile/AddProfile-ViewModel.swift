//
//  AddProfile-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import CoreData
import Foundation
import SwiftUI

extension AddProfile {
    @MainActor class AddProfileViewModel: ObservableObject {
        @Published var uiImage: UIImage = UIImage()
        @Published var name = ""
        @Published var email = ""
        @Published var title: TitleAccount = .currentAccount
        @Published var number = ""
        @Published var balance = 0.0
        @Published var color = Data()
        @Published var category: TransactionCategory = .salary
        @Published var date = Date.now
            
        @Published var showingAlert = false
        @Published var messageAlert = ""
        @Published var titleAlert = ""
        
        @ObservedObject var newProfileOrAccountViewModel = NewProfileOrAccount.NewProfileOrAccountViewModel()
        
//        let color1 = ColorEnum.allCases.randomElement() ?? .green
//        let color2 = ColorEnum.allCases.randomElement() ?? .orange
//        let color3 = ColorEnum.allCases.randomElement() ?? .pink
        
        var isDisabled: Bool {
            name.isEmpty || email.isEmpty || number.isEmpty
        }
        
        func selectAllText() {
            UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
        }
        
        func saveSession(account: String) {
            UserDefaults.standard.set(account, forKey: "session")
        }
        
        /*
        func saveData(moc: NSManagedObjectContext) {
            let profile = Profile(context: moc)
            profile.id = UUID()
            profile.name = name
            profile.photo = uiImage.jpegData(compressionQuality: 0.8)
            profile.email = email
            let account = Account(context: moc)
            account.id = UUID()
            account.profileParent = profile
            account.title = title.rawValue
            account.number = number
            account.balance = balance
            DataController.archiveColor(selectedAccount: account, colors: [color1.color, color2.color, color3.color])
            let transaction = Transaction(context: moc)
            transaction.id = UUID()
            transaction.accountParent = account
            transaction.amount = balance
            transaction.wrappedNature = .income
            transaction.date = date
            let categoryParent = Category(context: moc)
            categoryParent.id = UUID()
            transaction.categoryParent = categoryParent
            transaction.categoryParent?.category = category.rawValue
            
            do {
                try moc.save()
                saveSession(account: account.wrappedNumber)
            } catch {
                print("Failed to save data: \(error.localizedDescription)")
                showingAlert = true
                titleAlert = "Something went wrong!"
                messageAlert = AlertMessage.saveFailed.rawValue
            }
        }*/
        func saveData(moc: NSManagedObjectContext) {
            let profile = Profile(context: moc)
            profile.id = UUID()
            profile.name = name
            profile.photo = uiImage.jpegData(compressionQuality: 0.8)
            profile.email = email
            
            newProfileOrAccountViewModel.saveData(moc: moc, profile: profile, title: title, name: name, number: number, balance: balance, date: date, category: category)
            
            do {
                try moc.save()
//                saveSession(account: account.wrappedNumber)
                saveSession(account: number)
            } catch {
                print("Failed to save data: \(error.localizedDescription)")
                showingAlert = true
                titleAlert = "Something went wrong!"
                messageAlert = AlertMessage.saveFailed.rawValue
            }
        }
    }
}
