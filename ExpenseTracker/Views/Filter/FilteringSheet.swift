//
//  FilteringSheet.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 07/07/2023.
//

import CoreData
import SwiftUI

struct FilteringSheet: View {
    //MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @StateObject private var filteringSheetModel = FilterDateViewModel()
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ]) var transactions: FetchedResults<Transaction>
        
//    var onUpdate: (FilterDateViewModel) -> Void
    @Binding var transactionArray: [Transaction]
    @Binding var sectionFetchedArray: [SectionFetched]
    
//    init(transactionArray: [Transaction], sectionFetchedArray: [SectionFetched], onUpdate: @escaping (FilterDateViewModel) -> Void) {
//        self.transactionArray = transactionArray
//        self.sectionFetchedArray = sectionFetchedArray
//        self.onUpdate = onUpdate
//    }
  
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
                    if !filteringSheetModel.showingDatePicker {
                        Section {
                            ForEach(filteringSheetModel.dates, id: \.self) { text in
                                HStack {
                                    Text(text)
                                    Spacer()
                                    Image(systemName: filteringSheetModel.selectedMonth == text ? "dot.circle" : "circle")
                                }
                                .fontWeight(.bold)
                                .foregroundColor(text == "Narrow Date" ? .mint : .white)
                                .onTapGesture {
                                    filteringSheetModel.selectedMonth = text
                                    filteringSheetModel.filterTransactions(by: text, transactions: transactions)
                                    (transactionArray, sectionFetchedArray) = filteringSheetModel.updateArray(transactions: transactions)
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
                    
                    if filteringSheetModel.showingDatePicker {
                        VStack {
                            HStack {
                                Text("Narrow Date")
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: filteringSheetModel.showingDatePicker ? "chevron.down" : "chevron.right")
                            }
                            .foregroundColor(Color.mint)
                            .onTapGesture {
                                withAnimation {
                                    filteringSheetModel.showingDatePicker.toggle()
                                }
                            }
                            
                            VStack {
                                DatePicker("Begin", selection: $filteringSheetModel.beginDate, displayedComponents: .date)
//                                    .datePickerStyle(CompactDatePickerStyle())
                                    .id(filteringSheetModel.selectedIdOfDatePicker)
                                    .onChange(of: filteringSheetModel.beginDate) { newValue in
                                        withAnimation {
                                            filteringSheetModel.selectedIdOfDatePicker += 1
                                        }
                                    }
                                DatePicker("End", selection: $filteringSheetModel.finishedDate, displayedComponents: .date)
                                    .id(filteringSheetModel.selectedIdOfDatePicker)
                                    .onChange(of: filteringSheetModel.finishedDate) { newValue in
                                        withAnimation {
                                            filteringSheetModel.selectedIdOfDatePicker += 1
                                        }
                                    }
                            }
                            .foregroundColor(.secondary)
                            Button {
                                filteringSheetModel.filterNarrowDate(transactions: transactions)
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
        } //: ZStack
    } //: body
}


struct FilteringSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilteringSheet(transactionArray: .constant([Transaction]()), sectionFetchedArray: .constant([SectionFetched]()))
            .preferredColorScheme(.dark)
    }
}
