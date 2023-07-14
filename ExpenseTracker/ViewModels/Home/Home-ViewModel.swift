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
        
        func calculateSum(of nature: Transaction.NatureOfTransaction) -> Double {
            var array = [Double]()
            
            for transaction in transactionArray {
                if transaction.wrappedNature == nature {
                    array.append(transaction.amount)
                }
            }
           
            return array.reduce(0, +)
        }
        
        func fetchData(moc: NSManagedObjectContext, accountRequest: NSFetchRequest<Account>, transactions: FetchedResults<Transaction>) async {
            if let session = session {
                accountRequest.predicate = NSPredicate(format: "number == %@", session)
                selectedAccount = try? moc.fetch(accountRequest).first
                 
                let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
                transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
                
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
                if let sortedRequest = request.sortDescriptors {
                    transactions.nsSortDescriptors = sortedRequest
                }
                
                let temp = transactions.map { $0 }
                if temp.count >= 5 {
                    transactionArray = Array(temp.prefix(upTo: 5))
                } else {
                    transactionArray = temp
                }
               
                sumOfIncome = calculateSum(of: .income)
                sumOfExpenses = calculateSum(of: .expenses)
                
            }
        }
        
        func filterSearch(text: String, transactions: FetchedResults<Transaction>) {
            if let session = session {
                transactions.nsPredicate = text.isEmpty ? NSPredicate(format: "accountParent.number == %@", session) : NSPredicate(format: "accountParent.number == %@ AND categoryParent.category CONTAINS[c] %@", session, text)
                transactionArray = transactions.map { $0 }
            }
        }

    }
}
