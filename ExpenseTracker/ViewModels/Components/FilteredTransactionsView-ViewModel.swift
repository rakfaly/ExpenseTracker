//
//  FilteredTransactionsView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//
import CoreData
import Foundation
import SwiftUI


extension FilteredTransactionsView {
    @MainActor class FilteredTransactionsViewModel: ObservableObject {
        @AppStorage("session") private var session: String?
        @Published var seeAllItems: String = "See All"
        @Published var title = "Income"
        @Published var date = Date.now
        @Published var transactionCategory = TransactionCategory.salary
        @Published var amount = 0.0
        
        func deleteTransaction(at offsets: IndexSet, transactions: [Transaction], moc: NSManagedObjectContext) {
            for index in offsets {
                let transaction = transactions[index]
                moc.delete(transaction)
                if transaction.wrappedNature == .income {
                    transaction.accountParent?.balance -= transaction.amount
                } else {
                    transaction.accountParent?.balance += transaction.amount
                }
            }
            
            DataController.save(context: moc)
        }
        
        func fetchAll(moc: NSManagedObjectContext) async -> [Transaction] {
            let transactions: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            var transactionArray = [Transaction]()
            if let session = session {
                transactions.predicate = NSPredicate(format: "accountParent.number == %@", session)
                transactions.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
                do {
                    let temp = try moc.fetch(transactions)
                    if seeAllItems == "See All" {
                        transactionArray = temp.map { $0 }
                        seeAllItems = "Recent"
                    } else {
                        if temp.count >= 5 {
                            transactionArray = Array(temp.prefix(upTo: 5))
//                            transactions.fetchLimit = 5
                        } else {
                            transactionArray = temp.map { $0 }
                        }
                        seeAllItems = "See All"
                    }
                } catch {
                    print("Failed to fecth data \(error.localizedDescription)")
                }
            }
            
            return transactionArray
        }
    }
}

