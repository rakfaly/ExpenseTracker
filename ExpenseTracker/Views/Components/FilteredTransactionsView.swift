//
//  FilteredTransactionsView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 04/07/2023.
//

import CoreData
import SwiftUI

struct FilteredTransactionsView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) var moc
    @Binding var transactions: [Transaction]
    
    @Binding var listSectionTitle: String
    @StateObject private var filteredTransactionsViewModel = FilteredTransactionsViewModel()
            
    //MARK: - body
    var body: some View {
        List {
            Section {
                ForEach(transactions) { transaction in
                    NavigationLink {
                        AddView(title: $filteredTransactionsViewModel.title, transaction: transaction, date: $filteredTransactionsViewModel.date, transactionCategory: $filteredTransactionsViewModel.transactionCategory, amount: $filteredTransactionsViewModel.amount)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.categoryParent?.wrappedCategory ?? "Unknow Category")
                                    .font(.headline.weight(.semibold))
                                Text(transaction.wrappedDate, style: .date)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
            
                            Text(transaction.wrappedNature == .income ? "+$\(transaction.formattedAmount)" : "-$\(transaction.formattedAmount)")
                                .font(.headline.weight(.semibold))
                                .foregroundColor(transaction.wrappedNature == .income ? .green : Color.expenseColor)
                        } //: HStack
                    } //: NavigationLink
                }
                .onDelete { offset in
                    filteredTransactionsViewModel.deleteTransaction(at: offset, moc: moc, transactions: transactions)
                }
                .listRowBackground(Color.backgroundSecondary.opacity(0.2))
            } header: {
                HStack {
                    Text(listSectionTitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(filteredTransactionsViewModel.seeAllItems)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .underline()
                        .onTapGesture {
                            Task {
                                 transactions = await filteredTransactionsViewModel.fetchAll(moc: moc)
                            }
                        }
                }
            }
        } //: List
        .scrollContentBackground(.hidden)
        
    } //: body
}

struct FilteredTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredTransactionsView(transactions: .constant([Transaction]()), listSectionTitle: .constant("Last Added"))
    }
}
