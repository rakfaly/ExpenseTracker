//
//  AddIncome.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 01/07/2023.
//
import CoreData
import SwiftUI

struct AddView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @Binding var title: String
//    var transaction: Transaction
    var transaction: FetchedResults<Transaction>.Element?
    @Binding var date: Date
    @Binding var transactionCategory: TransactionCategory
    @Binding var amount: Double
    
    @State private var showingAlert: Bool = false
    @FocusState private var isFocused: Bool
    
    @State private var oldAmount: Double = 0
    
    var selectedAccount: FetchedResults<Account>.Element?

    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                if isFocused == false {
                    DatePicker("Select Date", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                }
                
                VStack(alignment: .leading) {
                    Text("\(title) Title")
                        .font(.subheadline)
                    Picker("Salary", selection: $transactionCategory) {
                        ForEach(TransactionCategory.allCases) {
                            Text($0.rawValue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(Capsule().stroke(lineWidth: 0.2))
                } //: VStack
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                            .font(.title.bold())
                            .foregroundColor(title == "Income" ? .green : Color.expenseColor)
                    }
                    Slider(value: $amount, in: 0...10000, step: 5)
                    
                } //: VStack
                
                Button {
                    save()
                    showingAlert.toggle()
                } label: {
                    Text("Save")
                        .font(.title.weight(.semibold))
                        .foregroundColor(.white)
                    
                } //: Button
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.buttonPurple)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.white, lineWidth: 1)
                )
                
            } //: VStack
            .navigationTitle("Add \(title)")
            .navigationBarTitleDisplayMode(.inline)
            .padding(30)
            .alert(DataController.alertTitle, isPresented: $showingAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(DataController.alertMessage)
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                }
                
                if isFocused {
                    ToolbarItem(placement: .keyboard) {
                        Button {
                            isFocused = false
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
            .task {
                await fetchData()
            }
        } //: ZStack
    } //: body
}

extension AddView {
    func save() {
        if let transaction = transaction {
            DataController.editTransaction(transaction: transaction, date: date, category: transactionCategory.rawValue, amount: amount, oldAmount: oldAmount, context: moc)
        } else {
            if let selectedAccount = selectedAccount {
                DataController.addTransaction(account: selectedAccount, nature: title, date: date, category: transactionCategory.rawValue, amount: amount, context: moc)
            }
        }
        
        
        /*
        if let transaction = transaction {
            if transaction.id == nil {
                transaction.id = UUID()
                transaction.nature = title == "Income" ? Transaction.NatureOfTransaction.income.rawValue : Transaction.NatureOfTransaction.expenses.rawValue
                
                let accountRequest: NSFetchRequest<Account> = Account.fetchRequest()
//                if let session = session {
//                    accountRequest.predicate = NSPredicate(format: "number == %@", session)
//                    selectedAccount = try? moc.fetch(accountRequest).first
//                }
//                transaction.accountParent = selectedAccount
//                if let account = selectedAccount {
//                    if title == "Income" {
//                        account.balance += amount
//                    } else {
//                        account.balance -= amount
//                    }
//                }
                   
            }  else {
                if let account = transaction.accountParent {
                    account.balance = title == "Income" ? (account.balance - oldAmount + amount) : (account.balance + oldAmount - amount)
                }
            }
            
            transaction.amount = amount
            transaction.date = date
            if transaction.categoryParent == nil {
                transaction.categoryParent = Category(context: moc)
            }
            transaction.categoryParent?.category = transactionCategory.rawValue
            
            DataController.save(context: moc)
        }
        /*
         guard let transaction = transaction else {
         print("Error occured")
         return
         }
         if transaction.accountParent == nil {
         let account = Account(context: moc)
         transaction.accountParent = account
         if title == "Income" {
         account.balance += amount
         } else {
         account.balance -= amount
         }
         transaction.nature = title == "Income" ? Transaction.NatureOfTransaction.income.rawValue : Transaction.NatureOfTransaction.expenses.rawValue
         } else {
         if let account = transaction.accountParent {
         account.balance = title == "Income" ? (account.balance - oldAmount + amount) : (account.balance + oldAmount - amount)
         }
         }
         //        transaction = Transaction(context: moc)
         //        transaction.id = UUID()
         transaction.amount = amount
         transaction.date = date
         if transaction.categoryParent == nil {
         transaction.categoryParent = Category(context: moc)
         }
         transaction.categoryParent?.category = transactionCategory.rawValue
         */
        //        DataController.save(context: moc)
         */
    }
    
    func fetchData() async {
        if let transaction = transaction {
            title = transaction.wrappedNature.rawValue
            date = transaction.wrappedDate
            if let category = transaction.categoryParent?.wrappedCategory {
                transactionCategory = TransactionCategory(rawValue: category) ?? .salary
            }
            amount = transaction.amount
            
            oldAmount = amount
        }
    }
}


struct AddIncome_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView(title: .constant("Expense"), transaction: Transaction(), date: .constant(Date.now), transactionCategory: .constant(.salary), amount: .constant(0.0))
                .preferredColorScheme(.dark)
        }
    }
}
