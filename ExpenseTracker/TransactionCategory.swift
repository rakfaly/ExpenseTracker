//
//  TransactionCategory.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 29/06/2023.
//

import Foundation


enum TransactionCategory: String, CaseIterable, Identifiable {
    case salary = "Salary"
    case groceries = "Groceries"
    case food = "Food"
    case transportation = "Transportation"
    case utilities = "Utilities"
    case entertainment = "Entertainment"
    case clothing = "Clothing"
    case healthcare = "Healthcare"
    case education = "Education"
    case travel = "Travel"
    case miscellaneous = "Miscellaneous"
    
    var id: Self { self }
}
