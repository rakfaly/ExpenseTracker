//
//  AccountListView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import CoreData
import Foundation
import SwiftUI

extension AccountListView {
    @MainActor class AccountListViewModel: ObservableObject {
        @AppStorage("session") private var session: String?
        @Published var showingAddAccountSheet = false
        
        @Published var name = ""
        @Published var email = ""
        @Published var uiImage = UIImage()
        
        @Published var title: TitleAccount = .currentAccount
        @Published var number = ""
        @Published var balance = 0.0
        @Published var category: TransactionCategory = .salary
        @Published var date = Date.now
        
        @Published var showingAlert = false
        @Published var messageAlert = ""
        @Published var titleAlert = ""
        
        @Published var selectedAccount = ""
                
        let color1 = ColorEnum.allCases.randomElement() ?? .green
        let color2 = ColorEnum.allCases.randomElement() ?? .orange
        let color3 = ColorEnum.allCases.randomElement() ?? .pink
        
        func saveData(accounts: FetchedResults<Account>, moc: NSManagedObjectContext) {
            guard let profile = accounts.last?.profileParent else {
                print("Faile to find profile")
                return
            }
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
                
                /*
                 showingAlert = true
                 titleAlert = "Confirmation"
                 messageAlert = AlertMessage.saveSucces.rawValue*/
            } catch {
                print("Failed to save data: \(error.localizedDescription)")
                showingAlert = true
                titleAlert = "Something went wrong!"
                messageAlert = AlertMessage.saveFailed.rawValue
            }
        }
        
        func deleteAccount(at offsets: IndexSet, accounts: FetchedResults<Account>, moc: NSManagedObjectContext) {
            for index in offsets {
                let account = accounts[index]
                moc.delete(account)
                if accounts.count <= 1 && account.wrappedNumber == session {
                    UserDefaults.standard.removeObject(forKey: "session")
                }
            }
            
            DataController.save(context: moc)
        }
    }
}
