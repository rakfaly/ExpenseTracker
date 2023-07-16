//
//  Home-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//
import CoreData
import Foundation
import SwiftUI

extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
        @AppStorage("session") private var session: String?
        @Published var selectedAccount: Account?
        @Published var sumOfIncome: Double?
        @Published var sumOfExpenses: Double?
        @Published var searchText = ""
        @Published var showingPopover = false
        @Published var seeAllItems = 5
        @Published var transactionArray = [Transaction]()
        @Published var transactionsRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        
        func calculateSum(of nature: Transaction.NatureOfTransaction) -> Double {
            var array = [Double]()
            
            for transaction in transactionArray {
                if transaction.wrappedNature == nature {
                    array.append(transaction.amount)
                }
            }
           
            return array.reduce(0, +)
        }
        
        func fetchData(moc: NSManagedObjectContext) async {
            let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
            if let session = session {
                accountRequest.predicate = NSPredicate(format: "number == %@", session)
                selectedAccount = try? moc.fetch(accountRequest).first
                 
                let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
                transactionsRequest.predicate = NSPredicate(format: "accountParent.number == %@", session)
                
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
                if let sortedRequest = request.sortDescriptors {
                    transactionsRequest.sortDescriptors = sortedRequest
                }
                
                let transactions = DataController.fetchTransactionsToArray(request: transactionsRequest, context: moc)
                if transactions.count >= 5 {
                    transactionArray = Array(transactions.prefix(upTo: 5))
                } else {
                    transactionArray = transactions
                }
               
                sumOfIncome = calculateSum(of: .income)
                sumOfExpenses = calculateSum(of: .expenses)
            }
        }
        
        func filterSearch(text: String, moc: NSManagedObjectContext) {
            if let session = session {
                transactionsRequest.predicate = text.isEmpty ? NSPredicate(format: "accountParent.number == %@", session) : NSPredicate(format: "accountParent.number == %@ AND categoryParent.category CONTAINS[c] %@", session, text)
                transactionArray = DataController.fetchTransactionsToArray(request: transactionsRequest, context: moc)
            }
        }

    }
}
