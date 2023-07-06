//
//  TransactionChart.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 04/07/2023.
//

import Charts
import SwiftUI

struct TransactionsChart: View {
    //MARK: - Properties
    @AppStorage("session") private var session: String?
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ]) var transactions: FetchedResults<Transaction>
    
    let stackColors: [Color] = [
        Color.green,
        Color.red
    ]
    
    //MARK: - body
    var body: some View {
        VStack {
            Text("Monthly Transactions")
                .font(.caption)
            Chart{
                ForEach(transactions) { transaction in
                    BarMark(
                        x: .value("Date", dateString(transaction: transaction)),
                        y: .value("Amount", transaction.amount)
                    )
                    .foregroundStyle(by: .value("Nature", transaction.wrappedNature.rawValue))
                    .position(by: .value("Nature", transaction.wrappedNature.rawValue))
                }
            }
            .chartForegroundStyleScale(range: stackColors)
            .frame(height: 160)
            .padding(.horizontal)
        }
    }
}

extension TransactionsChart {
    func dateString(transaction: Transaction) -> String{
        transaction.wrappedDate.formatted(date: .abbreviated, time: .omitted)
    }
}

struct TransactionsChart_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsChart()
    }
}
