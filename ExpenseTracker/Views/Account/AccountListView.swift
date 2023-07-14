//
//  AddAccountView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 03/07/2023.
//

import SwiftUI

struct AccountListView: View {
    //MARK: - Properties
    @AppStorage("session") private var session: String?
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.number)]) var accounts: FetchedResults<Account>
    
    @StateObject private var accountListViewModel = AccountListViewModel()
    @FocusState var isFocused: NewProfileOrAccount.FocusedField?
    
    var body: some View {
        List {
            ForEach(accounts, id: \.self) { (account: Account) in
                AccountRow(title: account.wrappedTitle, balance:account.balance, accountNumber: account.wrappedNumber, name: account.profileParent?.wrappedName ?? "Unknown Name", selectedAccount: $accountListViewModel.selectedAccount)
                    .listRowSeparator(.hidden)
                    .listRowBackground(accountListViewModel.selectedAccount != account.wrappedNumber ? Color.backgroundMain : Color.backgroundSecondary.opacity(0.1))
                    .listStyle(.inset)
            }
            .onDelete { offset in
                accountListViewModel.deleteAccount(at: offset, accounts: accounts, moc: moc)
            }
        } //: List
        .scrollContentBackground(.hidden)
        .background(Color.backgroundMain)
        .navigationTitle("Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup {
                EditButton()
                    .padding(.trailing, 20)
                
                Button {
                    withAnimation {
                        accountListViewModel.showingAddAccountSheet = true
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .fullScreenCover(isPresented: $accountListViewModel.showingAddAccountSheet) {
            VStack {
                HStack {
                    Button("Cancel") {
                        accountListViewModel.showingAddAccountSheet = false
                    }
                    Spacer()
                    Button("Save") {
                        accountListViewModel.saveData(accounts: accounts, moc: moc)
                        withAnimation {
                            accountListViewModel.showingAddAccountSheet = false
                        }
                    }
                    .disabled(accountListViewModel.number.isEmpty)
                } //: HStack
                .padding(.horizontal, 30)
                NewProfileOrAccount(isNewProfile: false, name: $accountListViewModel.name, email: $accountListViewModel.email, photo: $accountListViewModel.uiImage, title: $accountListViewModel.title, number: $accountListViewModel.number, balance: $accountListViewModel.balance, category: $accountListViewModel.category, date: $accountListViewModel.date, isFocused: _isFocused)
            }.background(Color.backgroundMain)
        }
        .onAppear {
            if let session = session {
                accountListViewModel.selectedAccount = session
            }
        }
    }
}

struct AddAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountListView()
                .preferredColorScheme(.dark)
        }
    }
}
