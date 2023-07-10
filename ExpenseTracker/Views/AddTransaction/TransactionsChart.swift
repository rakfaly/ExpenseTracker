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
    @Binding var groupedByDateTransactions: [SectionFetched]
        
    //MARK: - body
    var body: some View {
        VStack {
            Text("Monthly Transactions")
                .font(.caption)
            Chart{
                ForEach(groupedByDateTransactions, id: \.self) { transaction in
                    BarMark(
                        x: .value("Date", transaction.date),
                        y: .value("Amount", transaction.amounts),
                        width: 20
                    )
                    .foregroundStyle(by: .value("Nature", transaction.nature))
                    .position(by: .value("Nature", transaction.nature))
                    .annotation {
                        Text(transaction.amounts.formatted())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .chartForegroundStyleScale([
                "Income" : Color(.green),
                "Expenses": Color(.purple)])
//            .chartLegend(position: .top, alignment: .bottomTrailing)
//            .chartYAxis(.hidden)
            .padding()
        }
        .frame(height: 200)
    }
}

extension TransactionsChart {
    func dateString(transaction: Transaction) -> String{
        transaction.wrappedDate.formatted(date: .abbreviated, time: .omitted)
    }
}

struct TransactionsChart_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsChart(groupedByDateTransactions: .constant([SectionFetched]()))
    }
}
