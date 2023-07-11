//
//  GroupedByDate.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 10/07/2023.
//

import SwiftUI

struct SectionFetched: Hashable {
    var date: String
    var amounts: Double
    var nature: String
    
}

struct GroupingKey: Hashable {
    var date: String
    var nature: String
}

struct GroupedByDate {
    func getTransactionsGroupedByDate(transactions: [Transaction]) -> [SectionFetched] {
        let dictTransactions = Dictionary(grouping: transactions, by: { GroupingKey(date: $0.wrappedDate.formatted(date: .numeric, time: .omitted), nature: $0.wrappedNature.rawValue)})
        
        var amountGroupByDate: [GroupingKey: [Double]] = [:]
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Paris")
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")
        
        for groups in dictTransactions.keys {
            if let trx = dictTransactions[groups] {
                for transaction in trx {
                    _ = transaction.wrappedDate.formatted(date: .numeric, time: .omitted)
                    amountGroupByDate[groups, default: []].append(transaction.amount)
                }
            }
        }
        
        var sectionFetchedArray: [SectionFetched] = []
        
        for grp in amountGroupByDate.sorted(by: { dict1, dict2 in
            guard let date1 = dateFormatter.date(from: dict1.key.date), let date2 =  dateFormatter.date(from: dict2.key.date) else {
                return dict1.key.date < dict2.key.date
            }
            return date1 < date2
        }) {
            sectionFetchedArray.append(SectionFetched(date: grp.key.date, amounts: grp.value.reduce(0, +), nature: grp.key.nature))
        }
                                
        return sectionFetchedArray
        /*
        let dictTransactions = Dictionary(grouping: transactions, by: {$0.wrappedDate.formatted(date: .numeric, time: .omitted)})
        
        var amountsByDate: [Date: [Double]] = [:]
        var naturesByDate: [Date: [String]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        for dates in dictTransactions.keys {
            if let trx = dictTransactions[dates], let date = dateFormatter.date(from: dates) {
                for transaction in trx {
                    amountsByDate[date, default: []].append(transaction.amount)
                    naturesByDate[date, default: []].append(transaction.wrappedNature.rawValue)
                }
            }
        }
        
                
        var groupedAmounts: [Date: Double] = [:]
        var groupedNatures: [Date: String] = [:]
        
        for dict in amountsByDate.sorted(by: {$0.0 < $1.0}) {
            groupedAmounts[dict.key] = dict.value.reduce(0, +)
        }
        for dict in naturesByDate {
            groupedNatures[dict.key] = Set(dict.value.map {$0}).first
        }
        
        var sectionFetchedArray: [SectionFetched] = []
                
        for amountDate in groupedAmounts.keys {
            for natureDate in groupedNatures.keys {
                if amountDate == natureDate {
                    if let amount = groupedAmounts[amountDate], let nature = groupedNatures[amountDate] {
                        sectionFetchedArray.append(SectionFetched(date: amountDate, amounts: amount, nature: nature))
                    }
                }
            }
        }
                
        return sectionFetchedArray
         */
    }
}
