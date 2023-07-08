//
//  FilteringSheet.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 07/07/2023.
//

import SwiftUI

struct FilteringSheet: View {
    //MARK: - Properties
    @AppStorage("session") private var session: String?
    @Environment(\.dismiss) var dismiss
    
    @State private var title = "This Month"
    @State private var image = "circle"
    @State private var selected = "All"
    
    let dates = ["This Month", "Last Month", "Next Month", "This Year", "All", "Narrow"]
    
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>
//    @Binding var transactionArray: [Transaction]
    
    //MARK: - body
    var body: some View {
        ZStack {
            Color.backgroundMain.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .font(.largeTitle)
                    }
                } //: HStack
                
                List {
                    Section {
                        ForEach(dates, id: \.self) { text in
                            HStack {
                                Text(text)
                                Spacer()
                                Image(systemName: selected == text ? "dot.circle" : "circle")
                            }
                            .fontWeight(.bold)
                            .onTapGesture {
                                selected = text
                                filterTransactions(by: text)
                                dismiss()
                            }
                        }
                        .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
                    } header: {
                        Text("Choose")
                            .foregroundColor(.secondary)
                            .fontWeight(.semibold)
                    }
                } //: List
                .scrollContentBackground(.hidden)
                .frame(height: 320)
            } //: VStack
            .padding(.horizontal, 30)
        }
    }
}

extension FilteringSheet {
    func filterTransactions(by date: String) {
        if let session = session {
            if date == "Last Month" {
                guard let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.startOfDay(for: Date())), let endDate = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date())) else {
                    return
                }
                transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@ AND date >= %@ AND date <= %@", session, startDate as NSDate, endDate as NSDate)
            } else {
                transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
            }
            
//            transactionArray = transactions.map {$0}
        }
    }
}

struct FilteringSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilteringSheet()
            .preferredColorScheme(.dark)
    }
}
