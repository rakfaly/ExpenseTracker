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
    @AppStorage("session") private var session: String?
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>
    var accounts: NSFetchRequest<Account> = Account.fetchRequest()
//    @FetchRequest(sortDescriptors: [
//        SortDescriptor(\.date, order: .reverse)
//    ]) var transactions: FetchedResults<Transaction>
    let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()

    
    @State private var transactionArray = [Transaction]()
    
    var isAddView: Bool = true

    @State private var date = Date.now
    @State private var transactionCategory = TransactionCategory.salary
    @State private var amount = 0.0
    
    @State private var showingFilterSheet = false
    
    @State private var selectedAccount: Account?
    
    @State private var selectedFilter: String = "All"
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
                            AddView(title: .constant(Transaction.NatureOfTransaction.income.rawValue), date: $date, transactionCategory: $transactionCategory, amount: $amount, selectedAccount: selectedAccount)
                        } label: {
                            HeaderAddCardView(image: "square.and.arrow.down.fill", foregroundColor: .green, title: "Add Income", backgroundColor: .backgroundSecondary)
                        }

                        Spacer()

                        NavigationLink {
                            AddView(title: .constant(Transaction.NatureOfTransaction.expenses.rawValue), date: $date, transactionCategory: $transactionCategory, amount: $amount, selectedAccount: selectedAccount)
                        } label: {
                            HeaderAddCardView(image: "square.and.arrow.up.fill", foregroundColor: Color.expenseColor, title: "Add Expense", backgroundColor: .orangeBackground)
                        }
                    } //: HStack
                    .padding(.top, 30)
                    .padding(.horizontal, 30)
                }
                
                //MARK: - Chart View
                
                if !isAddView {
                    TransactionsChart(transactions: $transactionArray)
                        .padding(.vertical)
                }
                
                //MARK: - BODY LIST
                FilteredTransactionsView(transactions: $transactionArray, listSectionTitle: isAddView ? .constant("Last Added") : .constant("Transactions"))
            } //: VStack
        } //: VStack
        
        .navigationTitle(isAddView ? "Add Transactions" : "Overview")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isAddView {
                Button {
                    showingFilterSheet.toggle()
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilteringSheet(selected: $selectedFilter, transactionArray: $transactionArray)
                .presentationDetents([.medium])
        }
        .task {
            await fetchData()
        }
    } //: body
}
extension OverviewView {
    func fetchData() async {
        if let session = session {
            accounts.predicate = NSPredicate(format: "number == %@", session)
            selectedAccount = try? moc.fetch(accounts).first
            transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
            
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: isAddView ? false : true)]
            if let sortedRequest = request.sortDescriptors {
                transactions.nsSortDescriptors = sortedRequest
            }
            
            transactionArray = transactions.map { $0 }
        }
    }    
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OverviewView(isAddView: false)
                .preferredColorScheme(.dark)
        }
    }
}
