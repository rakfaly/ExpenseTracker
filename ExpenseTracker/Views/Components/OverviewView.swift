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
    
    @State private var transactionArray = [Transaction]()
    
    var isAddView: Bool = true

    @State private var date = Date.now
    @State private var transactionCategory = TransactionCategory.salary
    @State private var amount = 0.0
    
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
                            AddView(title: .constant("Income"), transaction: Transaction(context: moc))
                        } label: {
                            HeaderAddCardView(image: "square.and.arrow.down.fill", foregroundColor: .green, title: "Add Income", backgroundColor: .backgroundSecondary)
                        }

                        Spacer()

                        NavigationLink {
                            AddView(title: .constant("Expense"), transaction: Transaction(context: moc))
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
                FilteredTransactionsView(transactions: $transactionArray)
                
            } //: VStack
            .task {
                await fetchData()
            }
        } //: VStack
        .navigationTitle(isAddView ? "Add Transactions" : "Overview")
        .navigationBarTitleDisplayMode(.inline)
    } //: body
}
extension OverviewView {
    func fetchData() async {
        if let session = session {
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
        OverviewView(isAddView: true)
    }
}
