//
//  FilteringSheet-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import Foundation
import SwiftUI


extension FilteringSheet {
    @MainActor class FilterDateViewModel: ObservableObject {
        @AppStorage("session") private var session: String?
        
        @Published var title = "This Month"
        @Published var image = "circle"
        
        @Published var beginDate: Date = Date()
        @Published var finishedDate: Date = Date.now.addingTimeInterval(29 * 24 * 60 * 60)  //: next 30 days
        @Published var showingDatePicker = false
        @Published var selectedIdOfDatePicker = 0
        
        let dates = ["This Month", "Last Month", "Next Month", "This Year", "All", "Narrow Date"]
        @Published var selectedMonth = "This Month"
        
        func updateArray(transactions: FetchedResults<Transaction>) -> (transactionArray: [Transaction], sectionFetchedArray: [SectionFetched]) {
            let transactionArray = transactions.map { $0 }
            let groupedTransactions = GroupedByDate()
            let sectionFetchedArray = groupedTransactions.getTransactionsGroupedByDate(transactions: transactionArray)
            return (transactionArray, sectionFetchedArray)
        }
        
        func filterTransactions(by date: String, transactions: FetchedResults<Transaction>) {
            var dateManager = DateManager()
            var startDate = Date()
            var endDate = Date()
            
            if let session = session {
                switch date {
                case "This Month":
                    (startDate, endDate) = dateManager.getMonth(byAdding: 1)
                case "Last Month":
                    dateManager.firstDayComponents.month = dateManager.firstDayComponents.month! - 1
                    (startDate, endDate) = dateManager.getMonth(byAdding: 1)
                case "Next Month":
                    dateManager.firstDayComponents.month = dateManager.firstDayComponents.month! + 1
                    (startDate, endDate) = dateManager.getMonth(byAdding: 1)
                case "This Year":
                    (startDate, endDate) = dateManager.getYear(byAdding: 1)
                case "Narrow Date":
                    withAnimation {
                        showingDatePicker.toggle()
                    }
                    (startDate, endDate) = dateManager.getNarrowDates(beginDate: beginDate, endDate: finishedDate)
                default:
                    transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
                }
                
                if date != "All" {
                    let calendar = Calendar.current
                    let startOfDay = calendar.startOfDay(for: startDate)

                    (beginDate, finishedDate) = (startOfDay, endDate)
                    transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@ AND date >= %@ AND date <= %@", session, beginDate as NSDate, finishedDate as NSDate)
                }
            }
        }
        
        func filterNarrowDate(transactions: FetchedResults<Transaction>) {
            if let session = session {
                let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: finishedDate)
                if let endDay = endOfDay {
                    transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@ AND date >= %@ AND date <= %@", session, beginDate as NSDate, endDay as NSDate)
                }
            }
        }
    }
}
