//
//  AddTransactionView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import CoreData
import Foundation


extension AddView {
    @MainActor class AddViewModel: ObservableObject {
        @Published var showingAlert: Bool = false
        @Published var oldAmount: Double = 0
        
        @Published var date: Date = Date()
        @Published var transactionCategory: TransactionCategory = .salary
        @Published var amount: Double = 0.0
        
        func save(transaction: Transaction?, selectedAccount: Account?, moc: NSManagedObjectContext, nature: String) {
            if let transaction = transaction {
                DataController.editTransaction(transaction: transaction, date: date, category: transactionCategory.rawValue, amount: amount, oldAmount: oldAmount, context: moc)
            } else {
                if let selectedAccount = selectedAccount {
                    DataController.addTransaction(account: selectedAccount, nature: nature, date: date, category: transactionCategory.rawValue, amount: amount, context: moc)
                }
            }
        }
        
        func fetchData(transaction: Transaction?) async {
            if let transaction = transaction {
//                nature = transaction.wrappedNature.rawValue
                date = transaction.wrappedDate
                if let category = transaction.categoryParent?.wrappedCategory {
                    transactionCategory = TransactionCategory(rawValue: category) ?? .salary
                }
                amount = transaction.amount
                
                oldAmount = amount
            }
        }
    }
}
