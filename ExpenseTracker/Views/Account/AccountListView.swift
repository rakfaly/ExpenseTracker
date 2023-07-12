//
//  AddAccountView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 03/07/2023.
//

import SwiftUI

struct AccountListView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.number)]) var accounts: FetchedResults<Account>
    @AppStorage("session") private var session: String?
    @State private var showingAddAccountSheet = false
    
    @State private var name = ""
    @State private var email = ""
    @State private var uiImage = UIImage()
    
    @State private var title: TitleAccount = .currentAccount
    @State private var number = ""
    @State private var balance = 0.0
    @State private var category: TransactionCategory = .salary
    @State private var date = Date.now
    
    @State private var showingAlert = false
    @State private var messageAlert = ""
    @State private var titleAlert = ""
    
    @State private var selectedAccount = ""
    @FocusState var isFocused: NewProfileOrAccount.FocusedField?
    
    var body: some View {
        List {
            ForEach(accounts, id: \.self) { (account: Account) in
                AccountRow(title: account.wrappedTitle, balance:account.balance, accountNumber: account.wrappedNumber, name: account.profileParent?.wrappedName ?? "Unknown Name", selectedAccount: $selectedAccount)
                    .listRowSeparator(.hidden)
                    .listRowBackground(selectedAccount != account.wrappedNumber ? Color.backgroundMain : Color.backgroundSecondary.opacity(0.1))
                    .listStyle(.inset)
            }
            .onDelete { offset in
                deleteAccount(at: offset)
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
                        showingAddAccountSheet = true
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .fullScreenCover(isPresented: $showingAddAccountSheet) {
            VStack {
                HStack {
                    Button("Cancel") {
                        showingAddAccountSheet = false
                    }
                    Spacer()
                    Button("Save") {
                        saveData()
                        withAnimation {
                            showingAddAccountSheet = false
                        }
                    }
                    .disabled(number.isEmpty)
                } //: HStack
                .padding(.horizontal, 30)
                NewProfileOrAccount(isNewProfile: false, name: $name, email: $email, photo: $uiImage, title: $title, number: $number, balance: $balance, category: $category, date: $date, isFocused: _isFocused)
            }.background(Color.backgroundMain)
        }
        .onAppear {
            if let session = session {
                selectedAccount = session
            }
        }
    }
}

extension AccountListView {
    func saveData() {
        guard let profile = accounts.last?.profileParent else {
            print("Faile to find profile")
            return
        }
        let account = Account(context: moc)
        account.id = UUID()
        account.profileParent = profile
        account.title = title.rawValue
        account.number = number
        account.balance = balance
        let transaction = Transaction(context: moc)
        transaction.id = UUID()
        transaction.accountParent = account
        transaction.amount = balance
        transaction.wrappedNature = .income
        transaction.date = date
        let categoryParent = Category(context: moc)
        transaction.categoryParent = categoryParent
        transaction.categoryParent?.category = category.rawValue
        
        do {
            try moc.save()
            /*
             showingAlert = true
             titleAlert = "Confirmation"
             messageAlert = AlertMessage.saveSucces.rawValue*/
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
            showingAlert = true
            titleAlert = "Something went wrong!"
            messageAlert = AlertMessage.saveFailed.rawValue
        }
    }
    
    func deleteAccount(at offsets: IndexSet) {
        for index in offsets {
            let account = accounts[index]
            moc.delete(account)
            if account.wrappedNumber == session {
                UserDefaults.standard.removeObject(forKey: "session")
            }
        }
        
        DataController.save(context: moc)
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
