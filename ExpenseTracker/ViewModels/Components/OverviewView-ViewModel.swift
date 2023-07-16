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
        
        func fetchData(moc: NSManagedObjectContext, isAddView: Bool) async {
            if let session = session {
                let accounts: NSFetchRequest<Account> = Account.fetchRequest()
                accounts.predicate = NSPredicate(format: "number == %@", session)
                selectedAccount = try? moc.fetch(accounts).first
                
                let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
                request.predicate = NSPredicate(format: "accountParent.number == %@", session)
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: isAddView ? false : true)]
                
                transactionArray = DataController.fetchTransactionsToArray(request: request, context: moc)
                
                let groupedByDate = GroupedByDate()
                sectionFetchedArray = groupedByDate.getTransactionsGroupedByDate(transactions: transactionArray)
            }
        } 
    }
}
