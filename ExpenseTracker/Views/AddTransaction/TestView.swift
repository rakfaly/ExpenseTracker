//
//  TestView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 07/07/2023.
//

import SwiftUI

struct TestView: View {
    @AppStorage("session") var session: String?
    @SectionedFetchRequest<Date?, Transaction>(sectionIdentifier: \Transaction.date?, sortDescriptors: [
        SortDescriptor(\.date)
    ]) private var groupedTransactions
    
    @State private var sectionFecthed = [SectionFetched]()
    
    
    struct SectionFetched {
        var date: String
        var amounts: Double
        var nature: String
    }
    
    var body: some View {
        VStack {
            Text("Test")
            List {
//                Section {
                    ForEach(sectionFecthed, id: \.date) { transaction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.date)
                                    .font(.footnote)
                                Text(transaction.amounts, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            }
                            Spacer()
                            Text(transaction.nature)
                                .font(.footnote)
                        }
                    }
//                } header: {
//                    Text(transaction.date)
//                }
                .listRowBackground(Color.backgroundSecondary.opacity(0.3))
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundMain)
            .padding(30)
        }
        //            .listStyle(.plain)
        
        .background(Color.backgroundMain)
        .ignoresSafeArea()
        .task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        if let session = session {
            groupedTransactions.nsPredicate = NSPredicate(format: "accountParent.number == %@", session)
        }
        
        var groupedAmount: [String: [Double]] = [:]
        var groupedNature: [String: [String]] = [:]
        for groupedSection in groupedTransactions {
            if let id = groupedSection.id {
                let date = id.formatted(date: .abbreviated, time: .omitted)
                for transaction in groupedSection {
                    if date == transaction.wrappedDate.formatted(date: .abbreviated, time: .omitted) {
                        groupedAmount[date, default: []].append(transaction.amount)
                        groupedNature[date, default: []].append(transaction.wrappedNature.rawValue)
                    }
                }
            }
        }
        
        var totalAmounts: [String: Double] = [:]
        var groupedNatures: [String: String] = [:]
        
        for dict in groupedAmount {
            totalAmounts[dict.key] = dict.value.reduce(0, +)
            //            print(dict.value.reduce(0, +))
        }
        for temp in groupedNature {
            groupedNatures[temp.key] = Set(temp.value.map {$0}).first
        }
        //        print(totalAmounts)
        //        print(groupedNatures)
        
        for amount in totalAmounts.keys {
            for nature in groupedNatures.keys {
                if amount == nature {
                    if let amount1 = totalAmounts[amount], let nature1 = groupedNatures[amount] {
                        sectionFecthed.append(SectionFetched(date: amount, amounts: amount1, nature: nature1))
                    }
                }
            }
        }
        
        print(sectionFecthed)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
