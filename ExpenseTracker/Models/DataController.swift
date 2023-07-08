//
//  DataController.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "ExpenseTracker")
    static var alertTitle: String = "Confirmation"
    static var alertMessage: String = "Data saved with success!"
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    static func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            alertTitle = "Confirmation"
            alertMessage = "Data saved with success!"
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
            alertTitle = "Oops, someyhing went wrong!"
            alertMessage = "Failed to save data!"
        }
    }
    
    static func addTransaction(account: Account, nature: String, date: Date, category: String, amount: Double, context: NSManagedObjectContext) {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.accountParent = account
        transaction.amount = amount
        transaction.nature = nature
        transaction.date = date
        let categoryParent = Category(context: context)
        categoryParent.id = UUID()
        transaction.categoryParent = categoryParent
        transaction.categoryParent?.category = category
 
        
        transaction.accountParent?.balance = updateBalance(transaction: transaction, isNewTransaction: true, oldAmount: 0.0)
        
        save(context: context)
    }
    
    static func editTransaction(transaction: Transaction, date: Date, category: String, amount: Double, oldAmount: Double, context: NSManagedObjectContext) {
        transaction.date = date
        transaction.categoryParent?.category = category
        transaction.amount = amount
        transaction.accountParent?.balance = updateBalance(transaction: transaction, isNewTransaction: false, oldAmount: oldAmount)
        
        save(context: context)
    }
    
    static func updateBalance(transaction: Transaction, isNewTransaction: Bool, oldAmount: Double) -> Double {
        guard var balance = transaction.accountParent?.balance else {
            return 0.0
        }
        if transaction.wrappedNature == Transaction.NatureOfTransaction.income {
            if isNewTransaction {
                balance += transaction.amount
            } else {
                balance = balance - oldAmount + transaction.amount
            }
        } else {
            if isNewTransaction {
                balance -= transaction.amount
            } else {
                balance = balance + oldAmount - transaction.amount
            }
        }
        return balance
    }
}
