//
//  AddIncome.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 01/07/2023.
//

import SwiftUI

struct AddView: View {
    @AppStorage("session") private var session: String?
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var accounts: FetchedResults<Account>
    @State private var account: Account?
    
    @Binding var title: String
    @State private var date: Date = Date.now
    @State private var transactionCategory: TransactionCategory = .salary
    @State private var amount: Double = 0
    
    @State private var oldAmount: Double = 0
        
    @State private var showingAlert: Bool = false
    @FocusState private var isFocused: Bool
    
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>
    let transaction: Transaction?
    
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                DatePicker("Select Date", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                
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
                    Slider(value: $amount, in: 0...10000)
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
        }
    } //: body
}

extension AddView {
    func save() {
        guard let transaction = transaction else {
            print("Error occured")
            return
        }
        if transaction.accountParent == nil {
            transaction.accountParent = account
            if title == "Income" {
                account?.balance += amount
            } else {
                account?.balance -= amount
            }
            transaction.nature = title == "Income" ? Transaction.NatureOfTransaction.income.rawValue : Transaction.NatureOfTransaction.expenses.rawValue
        } else {
            if let accountBalance = account?.balance {
                account?.balance = title == "Income" ? (accountBalance - oldAmount + amount) : (accountBalance + oldAmount - amount)
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
        
        DataController.save(context: moc)
    }
    
    func fetchData() async {
        if let session = session {
            account = accounts.filter {
                $0.wrappedNumber == session
            }.first
        }
        
        guard let transaction = transaction else {
            print("Error Occured on fetchData")
            return
        }
        title = transaction.wrappedNature.rawValue
        date = transaction.wrappedDate
        if let category = transaction.categoryParent?.wrappedCategory {
            transactionCategory = TransactionCategory(rawValue: category) ?? .salary
        }
        amount = transaction.amount
        
        oldAmount = amount
 
    }
}

struct AddIncome_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView(title: .constant("Expense"), transaction: .none)
                .preferredColorScheme(.dark)
        }
    }
}
