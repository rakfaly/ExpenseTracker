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
    @Binding var selected: String
    
    @State private var beginDate: Date = Date()
    @State private var finishedDate: Date = Date.now.addingTimeInterval(29 * 24 * 60 * 60)  //: next 30 days
    @State private var showingDatePicker = false
    @State private var selectedIdOfDatePicker = 0
    
    let dates = ["This Month", "Last Month", "Next Month", "This Year", "All", "Narrow Date"]
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ]) var transactions: FetchedResults<Transaction>
    @Binding var transactionArray: [Transaction]
    @Binding var sectionFetchedArray: [SectionFetched]
    
    //MARK: - body
    var body: some View {
        ZStack {
            Color.backgroundMain.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
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
                    if !showingDatePicker {
                        Section {
                            ForEach(dates, id: \.self) { text in
                                HStack {
                                    Text(text)
                                    Spacer()
                                    Image(systemName: selected == text ? "dot.circle" : "circle")
                                }
                                .fontWeight(.bold)
                                .foregroundColor(text == "Narrow Date" ? .mint : .white)
                                .onTapGesture {
                                    selected = text
                                    filterTransactions(by: text)
                                    if text != "Narrow Date" {
                                        dismiss()
                                    }
                                }
                            }
                            .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
                        } header: {
                            Text("Choose")
                                .foregroundColor(.secondary)
                                .fontWeight(.semibold)
                        } //:Section
                    }
                    
                    if showingDatePicker {
                        VStack {
                            HStack {
                                Text("Narrow Date")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: showingDatePicker ? "chevron.down" : "chevron.right")
                            }
                            .foregroundColor(Color.mint)
                            .onTapGesture {
                                withAnimation {
                                    showingDatePicker.toggle()
                                }
                            }
                            
                            VStack {
                                DatePicker("Begin", selection: $beginDate, displayedComponents: .date)
                                    .id(selectedIdOfDatePicker)
                                    .onChange(of: beginDate) { newValue in
                                        withAnimation {
                                            selectedIdOfDatePicker += 1
                                        }
                                    }
                                DatePicker("End", selection: $finishedDate, displayedComponents: .date)
                                    .id(selectedIdOfDatePicker)
                                    .onChange(of: finishedDate) { newValue in
                                        withAnimation {
                                            selectedIdOfDatePicker += 1
                                        }
                                    }
                            }
                            .foregroundColor(.secondary)
                            Button {
                                if let session = session {
                                    let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: finishedDate)
                                    if let endDay = endOfDay {
                                        transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@ AND date >= %@ AND date <= %@", session, beginDate as NSDate, endDay as NSDate)
                                    }
                                    transactionArray = transactions.map { $0 }
                                    let groupedTransactions = GroupedByDate()
                                    sectionFetchedArray = groupedTransactions.getTransactionsGroupedByDate(transactions: transactionArray)
                                }
                                dismiss()
                            } label: {
                                Text("Search")
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10)))
                                    .background(Color.backgroundMain)
                                    .clipShape(Capsule())
                                    .overlay {
                                        Capsule()
                                            .stroke(.white, lineWidth: 1)
                                    }
                            }
                            .padding(.top, 30)
                        } //: VStack
                    }
                } //: List
                .scrollContentBackground(.hidden)
                //                .frame(height: 350)
                
            } //: VStack
            .padding(.horizontal, 30)
        }
    }
}

extension FilteringSheet {
    func filterTransactions(by date: String) {
        var dateManager = DateManager()
        var startDate = Date()
        var endDate = Date()
        
        if let session = session {
            switch date {
            case "This Month":
                (startDate, endDate) = dateManager.getMonth(byAdding: 1)
            case "Last Month":
                dateManager.firstDayComponents.month = dateManager.firstDayComponents.month! - 1
                (startDate, endDate) = dateManager.getMonth(byAdding: 1)
            case "Next Month":
                dateManager.firstDayComponents.month = dateManager.firstDayComponents.month! + 1
                (startDate, endDate) = dateManager.getMonth(byAdding: 1)
            case "This Year":
                (startDate, endDate) = dateManager.getYear(byAdding: 1)
            case "Narrow Date":
                withAnimation {
                    showingDatePicker.toggle()
                }
                (startDate, endDate) = dateManager.getNarrowDates(beginDate: beginDate, endDate: finishedDate)
            default:
                transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
            }
            
            if date != "All" {
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: startDate)

                (beginDate, finishedDate) = (startOfDay, endDate)
                transactions.nsPredicate = NSPredicate(format: "accountParent.number == %@ AND date >= %@ AND date <= %@", session, beginDate as NSDate, finishedDate as NSDate)
            }
            transactionArray = transactions.map {$0}
            let groupedTransactions = GroupedByDate()
            sectionFetchedArray = groupedTransactions.getTransactionsGroupedByDate(transactions: transactionArray)
        }
    }
}

struct FilteringSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilteringSheet(selected: .constant("All"), transactionArray: .constant([Transaction]()), sectionFetchedArray: .constant([SectionFetched]()))
            .preferredColorScheme(.dark)
    }
}
