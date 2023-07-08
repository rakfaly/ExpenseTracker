//
//  AddProfile.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import SwiftUI

struct AddProfile: View {
    //MARK: - Properties    
    @Environment(\.managedObjectContext) var moc
    
    @State private var name = ""
    @State private var email = ""
    @State private var title: TitleAccount = .currentAccount
    @State private var number = ""
    @State private var balance = 0.0
    @State private var category: TransactionCategory = .salary
    @State private var date = Date.now
        
    @State private var showingAlert = false
    @State private var messageAlert = ""
    @State private var titleAlert = ""
        
    @FocusState var isFocused: NewProfileOrAccount.FocusedField?
    
    var isDisabled: Bool {
        name.isEmpty || email.isEmpty
    }
            
    //MARK: - Body
    var body: some View {
        NewProfileOrAccount(name: $name, email: $email, title: $title, number: $number, balance: $balance, category: $category, date: $date, isFocused: _isFocused)
        .navigationTitle("Add Profile")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundSecondary)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AppTabView()
                } label: {
                    Text("Save")
                } .simultaneousGesture(TapGesture().onEnded({ _ in
                    saveData()
                }))
                .padding(.trailing)
                .disabled(isDisabled)
            }
            
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            
            if isFocused == .decimal {
                ToolbarItem(placement: .keyboard) {
                    Button {
                        isFocused = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
        .alert(titleAlert, isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(messageAlert)
        }
    }
}

extension AddProfile {
    func saveData() {
        let profile = Profile(context: moc)
        profile.id = UUID()
        profile.name = name
        profile.email = email
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
        categoryParent.id = UUID()
        transaction.categoryParent = categoryParent
        transaction.categoryParent?.category = category.rawValue
                        
        do {
            try moc.save()
            saveSession(account: account.wrappedNumber)
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
    
    func selectAllText() {
        UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
    }
    
    func saveSession(account: String) {
        UserDefaults.standard.set(account, forKey: "session")
    }
}


//MARK: - Preview
struct AddProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddProfile()
                .preferredColorScheme(.dark)
        }
    }
}
