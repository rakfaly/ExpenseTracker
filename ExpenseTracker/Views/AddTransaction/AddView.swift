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
    
    var nature: String
    var transaction: FetchedResults<Transaction>.Element?
    var selectedAccount: FetchedResults<Account>.Element?
    @FocusState private var isFocused: Bool
    @StateObject private var addViewModel = AddViewModel()
    
    
    //MARK: - body
    var body: some View {
        ZStack {
            Color.backgroundMain
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                if isFocused == false {
                    DatePicker("Select Date", selection: $addViewModel.date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                }
                
                VStack(alignment: .leading) {
                    Text("\(nature) Title")
                        .font(.subheadline)
                    Picker("Salary", selection: $addViewModel.transactionCategory) {
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
                        TextField("Amount", value: $addViewModel.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                            .font(.title.bold())
                            .foregroundColor(nature == Transaction.NatureOfTransaction.income.rawValue ? .green : Color.expenseColor)
                    }
                    Slider(value: $addViewModel.amount, in: 0...10000, step: 5)
                    
                } //: VStack
                
                Button {
                    addViewModel.save(transaction: transaction, selectedAccount: selectedAccount, moc: moc, nature: nature)
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
            .navigationTitle("Add \(nature)")
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
                await addViewModel.fetchData(transaction: transaction)
            }
        } //: ZStack
    } //: body
}


struct AddIncome_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView(nature: "Income", transaction: nil)
                .preferredColorScheme(.dark)
        }
    }
}
