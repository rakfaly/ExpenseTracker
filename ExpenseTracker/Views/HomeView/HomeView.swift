//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 27/06/2023.
//
import CoreData
import SwiftUI

struct HomeView: View {
    //MARK: - Properties
    @AppStorage("session") private var session: String?
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var accounts: FetchedResults<Account>
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ]) var transactions: FetchedResults<Transaction>
    
    let request: NSFetchRequest<Account> = Account.fetchRequest()
    @State private var selectedAccount: Account?
    
    @State var sumOfIncome: Double?
    @State var sumOfExpenses: Double?
    
    @State private var searchText = ""
    @State private var showingPopover = false
        
    //MARK: - body
    var body: some View {
        VStack {
            //MARK: - Account Card
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Total Balance")
                            .font(.caption.weight(.semibold))
                        Image(systemName: "chevron.down")
                        
                        Spacer()
                        
                        Button {
                            showingPopover.toggle()
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .popover(isPresented: $showingPopover) {
                            AccountListPopOverView()
                                .frame(width: 200, height: 150)
                                .presentationCompactAdaptation(.popover)
                                .onDisappear {
                                    Task {
                                        await fetchData(transactions: transactions)
                                    }
                                }
                        }
                    }
                    .font(.footnote)
                    .padding(.bottom, -1)
                    Text(selectedAccount?.balance ?? 0.0 , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.title2.weight(.bold))
                }
                .padding()
                
                HStack {
                    VStack(spacing: 5) {
                        Label("Income", systemImage: "arrow.down.circle.fill")
                        Text(sumOfIncome ?? 0.0, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.subheadline.weight(.semibold))
                    }
                    Spacer()
                    VStack(spacing: 5) {
                        Label("Expenses", systemImage: "arrow.up.circle.fill")
                        Text(sumOfExpenses ?? 0.0, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.subheadline.weight(.semibold))
                    }
                }
                .padding()
            } //: VStack
            .background(LinearGradient(gradient: Gradient(colors: [
                Color.blue,
                Color.purple,
                Color.orange]), startPoint: .bottomLeading, endPoint: .topTrailing))
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.vertical, 20)
            .padding(.horizontal, 30)
            
            //MARK: - Transactions list
//            List {
//                Section {
//                    ForEach(transactions) { transaction in
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text(transaction.categoryParent?.wrappedCategory ?? "Unknow Category")
//                                    .font(.headline.weight(.semibold))
//                                Text(transaction.wrappedDate, style: .date)
//                                    .font(.footnote)
//                                    .foregroundColor(.secondary)
//                            }
//                            Spacer()
//                            //                            Text(transaction.wrappedNature == .income ? +transaction.amount : -transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
//                            Text(transaction.wrappedNature == .income ? "+$\(transaction.formattedAmount)" : "-$\(transaction.formattedAmount)")
//                                .font(.headline.weight(.semibold))
//                                .foregroundColor(transaction.wrappedNature == .income ? .green : Color.expenseColor)
//                        }
//                    }
//                    .listRowBackground(Color.backgroundSecondary.opacity(0.2))
//                } header: {
//                    HStack {
//                        Text("Transactions")
//                            .fontWeight(.semibold)
//                        Spacer()
//                        Text("See All")
//                            .font(.caption)
//                    }
//                }
//            } //: List
//            .scrollContentBackground(.hidden)
//            .listRowInsets(EdgeInsets())
            
            FilteredTransactionsView(transactions: _transactions)
            .listRowSeparator(.hidden)
            .searchable(text: $searchText, placement: SearchFieldPlacement.toolbar, prompt: "Search transactions")
            .onChange(of: searchText) { newValue in
                filterSearch(text: newValue)
            }
            .task {
                await fetchData(transactions: transactions)
            }
        } //: VStack
        .frame(maxWidth: .infinity)
        .background(Color.backgroundMain)
    } //: body
}

extension HomeView {
    func calculateSum(of nature: Transaction.NatureOfTransaction) -> Double {
        var array = [Double]()
        
        if let transactions = selectedAccount?.wrappedTransactions {
            for transaction in transactions {
                if transaction.wrappedNature == nature {
                    array.append(transaction.amount)
                }
            }
        }
        return array.reduce(0, +)
    }
    
    func fetchData(transactions: FetchedResults<Transaction>) async {
        if let session = session {
            request.predicate = NSPredicate(format: "number == %@", session)
            selectedAccount = try? moc.fetch(request).first
            
            let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
            
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
            if let sortedRequest = request.sortDescriptors {
                transactions.nsSortDescriptors = sortedRequest
            }
            
            sumOfIncome = calculateSum(of: .income)
            sumOfExpenses = calculateSum(of: .expenses)
            
        }
        
//        if let session = session {
//            request.predicate = NSPredicate(format: "number == %@", session)
//            selectedAccount = try? moc.fetch(request).first
//            //                selectedAccount = accounts.filter {
//            //                    $0.wrappedNumber == session
//            //                }.first
//            if let accountNumber = selectedAccount?.wrappedNumber {
//                transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", accountNumber)
//            }
//
//            sumOfIncome = calculateSum(of: .income)
//            sumOfExpenses = calculateSum(of: .expenses)
//        }
    }
    
    func filterSearch(text: String) {
        if let session = session {
            transactions.nsPredicate = text.isEmpty ? NSPredicate(format: "accountParent.number == %@", session) : NSPredicate(format: "accountParent.number == %@ AND categoryParent.category CONTAINS[c] %@", session, text)
        }
    }
}


//MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}
