//
//  AccountManager.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 01/07/2023.
//

import Foundation

class AccountManager: ObservableObject {
    @Published var accounts: [Account] = []
    
    func addAccount(_ account: Account) {
        accounts.append(account)
    }
}
