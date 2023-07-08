//
//  TransactionChart.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 04/07/2023.
//

import Charts
import CoreData
import SwiftUI

struct TransactionsChart: View {
    //MARK: - Properties
    @AppStorage("session") private var session: String?
    @Binding var transactions: [Transaction]
    
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
                        y: .value("Amount", transaction.amount),
                        width: 50
                    )
                    .foregroundStyle(by: .value("Nature", transaction.wrappedNature.rawValue))
                    .position(by: .value("Nature", transaction.wrappedNature.rawValue))
                    .annotation {
                        Text(transaction.formattedAmount)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .chartForegroundStyleScale(range: stackColors)
            .padding(.horizontal)
        }
        .frame(height: 160)
    }
}

extension TransactionsChart {
    func dateString(transaction: Transaction) -> String{
        transaction.wrappedDate.formatted(date: .abbreviated, time: .omitted)
    }
}

struct TransactionsChart_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsChart(transactions: .constant([Transaction]()))
    }
}
