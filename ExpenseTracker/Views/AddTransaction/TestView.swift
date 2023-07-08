//
//  TestView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 07/07/2023.
//

import SwiftUI

struct TestView: View {
    @Binding var title: String
    let transaction: Transaction?
    var body: some View {
        if let transaction = transaction {
            VStack {
                Text("UUID: \(transaction.wrappedId)")
                Text(title)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(title: .constant("Income"), transaction: Transaction())
    }
}
