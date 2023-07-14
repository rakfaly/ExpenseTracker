//
//  AddTransactionView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import Foundation


extension AddView {
    @MainActor class AddViewModel: ObservableObject {
        @Published var showingAlert: Bool = false
        @Published var oldAmount: Double = 0

    }
}
