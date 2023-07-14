//
//  OverviewView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 04/07/2023.
//
import CoreData
import SwiftUI

struct OverviewView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>
    var accounts: NSFetchRequest<Account> = Account.fetchRequest()
    let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
    
    var isAddView: Bool
    @StateObject private var overviewViewModel = OverviewViewModel()
    
    //MARK: - body
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                //MARK: - HEADER
                if isAddView {
                    HStack {
                        NavigationLink {
                            AddView(title: .constant(Transaction.NatureOfTransaction.income.rawValue), date: $overviewViewModel.date, transactionCategory: $overviewViewModel.transactionCategory, amount: $overviewViewModel.amount, selectedAccount: overviewViewModel.selectedAccount)
                        } label: {
                            HeaderAddCardView(image: "square.and.arrow.down.fill", foregroundColor: .green, title: "Add Income", backgroundColor: .backgroundSecondary)
                        }

                        Spacer()

                        NavigationLink {
                            AddView(title: .constant(Transaction.NatureOfTransaction.expenses.rawValue), date: $overviewViewModel.date, transactionCategory: $overviewViewModel.transactionCategory, amount: $overviewViewModel.amount, selectedAccount: overviewViewModel.selectedAccount)
                        } label: {
                            HeaderAddCardView(image: "square.and.arrow.up.fill", foregroundColor: Color.expenseColor, title: "Add Expense", backgroundColor: .orangeBackground)
                        }
                    } //: HStack
                    .padding(.top, 30)
                    .padding(.horizontal, 30)
                }
                
                //MARK: - Chart View
                
                if !isAddView {
                    TransactionsChart(groupedByDateTransactions: $overviewViewModel.sectionFetchedArray)
                        .padding(.vertical)
                        
                }
                
                //MARK: - BODY LIST
                FilteredTransactionsView(transactions: $overviewViewModel.transactionArray, listSectionTitle: isAddView ? .constant("Last Added") : .constant("Transactions"))
            } //: VStack
        } //: VStack
        
        .navigationTitle(isAddView ? "Add Transactions" : "Overview")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isAddView {
                Button {
                    overviewViewModel.showingFilterSheet.toggle()
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .sheet(isPresented: $overviewViewModel.showingFilterSheet) {
            FilteringSheet(transactionArray: $overviewViewModel.transactionArray, sectionFetchedArray: $overviewViewModel.sectionFetchedArray)
                .presentationDetents([.medium])
        }
        .task {
            await overviewViewModel.fetchData(moc: moc, transactions: transactions, accounts: accounts, isAddView: isAddView)
        }
    } //: body
}


struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OverviewView(isAddView: false)
                .preferredColorScheme(.dark)
        }
    }
}
