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
        
        @StateObject var newProfileOrAccountViewModel = NewProfileOrAccount.NewProfileOrAccountViewModel()
        
        func saveData(accounts: FetchedResults<Account>, moc: NSManagedObjectContext) {
            guard let profile = accounts.last?.profileParent else {
                print("Faile to find profile")
                return
            }
            newProfileOrAccountViewModel.saveData(moc: moc, profile: profile, title: title, name: name, number: number, balance: balance, date: date, category: category)
            
            do {
                try moc.save()
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
