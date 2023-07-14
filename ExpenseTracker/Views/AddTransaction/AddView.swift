//
//  AddIncome.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 01/07/2023.
//
import CoreData
import SwiftUI

struct AddView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @Binding var title: String
//    var transaction: Transaction
    var transaction: FetchedResults<Transaction>.Element?
    @Binding var date: Date
    @Binding var transactionCategory: TransactionCategory
    @Binding var amount: Double
    
    @FocusState private var isFocused: Bool    
    var selectedAccount: FetchedResults<Account>.Element?
    
    @StateObject private var addViewModel = AddViewModel()

    
    //MARK: - body
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
                    addViewModel.showingAlert.toggle()
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
            .alert(DataController.alertTitle, isPresented: $addViewModel.showingAlert) {
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
            DataController.editTransaction(transaction: transaction, date: date, category: transactionCategory.rawValue, amount: amount, oldAmount: addViewModel.oldAmount, context: moc)
        } else {
            if let selectedAccount = selectedAccount {
                DataController.addTransaction(account: selectedAccount, nature: title, date: date, category: transactionCategory.rawValue, amount: amount, context: moc)
            }
        }
    }
    
    func fetchData() async {
        if let transaction = transaction {
            title = transaction.wrappedNature.rawValue
            date = transaction.wrappedDate
            if let category = transaction.categoryParent?.wrappedCategory {
                transactionCategory = TransactionCategory(rawValue: category) ?? .salary
            }
            amount = transaction.amount
            
            addViewModel.oldAmount = amount
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
