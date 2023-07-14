//
//  OverviewView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import CoreData
import Foundation
import SwiftUI


extension OverviewView {
    @MainActor class OverviewViewModel: ObservableObject {
        @AppStorage("session") private var session: String?
        @Published var transactionArray = [Transaction]()
        @Published var date = Date.now
        @Published var transactionCategory = TransactionCategory.salary
        @Published var amount = 0.0
        @Published var showingFilterSheet = false
        @Published var selectedAccount: Account?
        @Published var sectionFetchedArray = [SectionFetched]()
        
        func fetchData(moc: NSManagedObjectContext, transactions: FetchedResults<Transaction>, accounts: NSFetchRequest<Account>, isAddView: Bool) async {
            if let session = session {
                accounts.predicate = NSPredicate(format: "number == %@", session)
                selectedAccount = try? moc.fetch(accounts).first
                transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
                
                let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: isAddView ? false : true)]
                if let sortedRequest = request.sortDescriptors {
                    transactions.nsSortDescriptors = sortedRequest
                }
                
                transactionArray = transactions.map { $0 }
                
                let groupedByDate = GroupedByDate()
                sectionFetchedArray = groupedByDate.getTransactionsGroupedByDate(transactions: transactionArray)
            }
        } 
    }
}
