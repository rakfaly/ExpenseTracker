//
//  NewProfileOrAccount.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 03/07/2023.
//

import SwiftUI

struct NewProfileOrAccount: View {
    //MARK: - Properties
    var isNewProfile = true
    
    @Binding var name: String
    @Binding var email: String
    @Binding var photo: UIImage
    @Binding var title: TitleAccount
    @Binding var number: String
    @Binding var balance: Double
    @Binding var category: TransactionCategory
    @Binding var date: Date
    @FocusState var isFocused: FocusedField?
    
    enum FocusedField {
        case decimal
    }

    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingPhotoSheet = false
    
    //MARK: - Body
    var body: some View {
        VStack {
            ImageView(photo: $photo, image: $image)
            
            Form {
                Group {
                    if isNewProfile {
                        Section {
                                TextField("Name", text: $name)
                                TextField("Email", text: $email)
                            } header: {
                                Text("User")
                                    .foregroundColor(.secondary)
                            }
                    }
                    Section {
                        Picker(selection: $title) {
                            ForEach(TitleAccount.allCases) { item in
                                Text(item.rawValue)
                            }
                        } label: {
                            Text("Title")
                                .foregroundColor(.backgroundSecondary)
                        }
                        TextField("Number", text: $number)
                    } header: {
                        Text("Account")
                            .foregroundColor(.secondary)
                    }
                    
                    Section {
                        TextField("Balance", value: $balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .focused($isFocused, equals: .decimal)
                            .keyboardType(.decimalPad)
                            .onChange(of: isFocused) { newValue in
                                if newValue == .decimal {
                                    selectAllText()
                                }
                            }
                        Picker("Category", selection: $category) {
                            ForEach(TransactionCategory.allCases) {
                                Text($0.rawValue)
                                    .tint(.red)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        DatePicker(selection: $date, displayedComponents: .date) {
                            Text("Date")
                        }
                        .datePickerStyle(.compact)
                        //                .labelsHidden()
                    } header: {
                        Text("Initial Balance")
                            .foregroundColor(.secondary)
                    }
                }
                .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
                
            } //: Form
            .scrollContentBackground(.hidden)
        }
        .background(Color.backgroundMain)
    } //: body
}

extension NewProfileOrAccount {
    func selectAllText() {
        UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
    }
}


struct NewProfileOrAccount_Previews: PreviewProvider {
    static var previews: some View {
        NewProfileOrAccount(name: .constant("Taylor Swift"), email: .constant("taylo@swift.com"), photo: .constant(UIImage()), title: .constant(.currentAccount), number: .constant("1234 5678 9012 3456"), balance: .constant(2500), category: .constant(.salary), date: .constant(Date.now))
            .preferredColorScheme(.dark)
    }
}
