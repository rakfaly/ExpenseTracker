//
//  TitleAccount.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 05/07/2023.
//

import Foundation

enum TitleAccount: String, CaseIterable, Identifiable {
    case currentAccount = "Current account"
    case savingsAccount = "Savings account"
    case cash = "Cash"
    
    var id: Self { self }
}
