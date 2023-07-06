//
//  AlertMessage.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import Foundation


enum AlertMessage: String {
    case databaseError = "Error occured on database file"
    case saveFailed = "Failed to save data"
    case loadFailed = "Failed to load data"
    case saveSucces = "Data saved successfully"
}
