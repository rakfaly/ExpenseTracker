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
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var accounts: FetchedResults<Account>
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ]) var transactions: FetchedResults<Transaction>
    
    let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
    
    @StateObject private var homeViewModel = HomeViewModel()
    
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
                            homeViewModel.showingPopover.toggle()
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .popover(isPresented: $homeViewModel.showingPopover) {
                            AccountListPopOverView()
                                .frame(width: 200, height: 150)
                                .presentationCompactAdaptation(.popover)
                                .onDisappear {
                                    Task {
                                        await homeViewModel.fetchData(moc: moc, accountRequest: accountRequest, transactions: transactions)
                                    }
                                }
                        }
                    }
                    .font(.footnote)
                    .padding(.bottom, -1)
                    Text(homeViewModel.selectedAccount?.balance ?? 0.0 , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.title2.weight(.bold))
                }
                .padding()
                
                HStack {
                    VStack(spacing: 5) {
                        Label("Income", systemImage: "arrow.down.circle.fill")
                        Text(homeViewModel.sumOfIncome ?? 0.0, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.subheadline.weight(.semibold))
                    }
                    Spacer()
                    VStack(spacing: 5) {
                        Label("Expenses", systemImage: "arrow.up.circle.fill")
                        Text(homeViewModel.sumOfExpenses ?? 0.0, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
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
            FilteredTransactionsView(transactions: $homeViewModel.transactionArray, listSectionTitle: .constant("Last Transactions"))
            .listRowSeparator(.hidden)
            .searchable(text: $homeViewModel.searchText, placement: SearchFieldPlacement.toolbar, prompt: "Search transactions")
            .onChange(of: homeViewModel.searchText) { newValue in
                homeViewModel.filterSearch(text: newValue, transactions: transactions)
            }
            .task {
                await homeViewModel.fetchData(moc: moc, accountRequest: accountRequest, transactions: transactions)
            }
        } //: VStack
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundMain)
    } //: body
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
