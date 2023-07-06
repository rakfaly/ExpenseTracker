//
//  Transaction+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 29/06/2023.
//
//

import Foundation
import CoreData


extension Transaction {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var nature: String?
    @NSManaged public var amount: Double
    @NSManaged public var accountParent: Account?
    @NSManaged public var categoryParent: Category?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    var wrappedNature: NatureOfTransaction {
        get {
            Transaction.NatureOfTransaction(rawValue: nature ?? "Income") ?? .income
        }
        set {
            nature = newValue.rawValue
        }
    }
    
    public var formattedAmount: String {
        String(format: "%.2f", amount)
    }
    
    public var wrappedDate: Date {
        date ?? Date.now
    }
    
    enum NatureOfTransaction: String {
        case income = "Income"
        case expenses = "Expenses"
    }
    
}

extension Transaction : Identifiable {
    
}
