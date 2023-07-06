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
    @AppStorage("session") private var session: String?
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>
    
    @State private var title = "Income"
    @State private var date = Date.now
    @State private var transactionCategory = TransactionCategory.salary
    @State private var amount = 0.0
        
    //MARK: - body
    var body: some View {
        List {
            Section {
                ForEach(transactions, id: \.wrappedId) { transaction in
                    NavigationLink {
                        AddView(title: $title, transaction: transaction)
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
                    deleteTransaction(at: offset)
                }
                .listRowBackground(Color.backgroundSecondary.opacity(0.2))
            } header: {
                Text("Last Added")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        } //: List
        .scrollContentBackground(.hidden)
    } //: body
}

extension FilteredTransactionsView {
    func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            moc.delete(transaction)
            if transaction.wrappedNature == .income {
                transaction.accountParent?.balance -= transaction.amount
            } else {
                transaction.accountParent?.balance += transaction.amount
            }
        }
        
        do {
            try moc.save()
        } catch {
            print("Failed to delete data")
        }
    }
}

struct FilteredTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredTransactionsView()
    }
}
