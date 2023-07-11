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
    @Binding var transactions: [Transaction]
    
    @Binding var listSectionTitle: String
    @State private var seeAllItems: String = "See All"
        
    @State private var title = "Income"
    @State private var date = Date.now
    @State private var transactionCategory = TransactionCategory.salary
    @State private var amount = 0.0
            
    //MARK: - body
    var body: some View {
        List {
            Section {
                ForEach(transactions) { transaction in
                    NavigationLink {
                        AddView(title: $title, transaction: transaction, date: $date, transactionCategory: $transactionCategory, amount: $amount)
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
                HStack {
                    Text(listSectionTitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(seeAllItems)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .underline()
                        .onTapGesture {
                            Task {
                                await fetchAll()
                            }
                        }
                }
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
        
        DataController.save(context: moc)
    }
    
    func fetchAll() async {
        let data: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        if let session = session {
            data.predicate = NSPredicate(format: "accountParent.number == %@", session)
            data.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
            do {
                let temp = try moc.fetch(data)
                if seeAllItems == "See All" {
                    transactions = temp
                    seeAllItems = "Recent"
                } else {
                    if temp.count >= 5 {
                        transactions = Array(temp.prefix(upTo: 5))
                    } else {
                        transactions = temp
                    }
                    seeAllItems = "See All"
                }
            } catch {
                print("Failed to fecth data \(error.localizedDescription)")
            }
        }
    }
}

struct FilteredTransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredTransactionsView(transactions: .constant([Transaction]()), listSectionTitle: .constant("Last Added"))
    }
}
