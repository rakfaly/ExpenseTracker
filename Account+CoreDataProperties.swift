//
//  Account+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 15/07/2023.
//
//

import Foundation
import CoreData
import SwiftUI


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var balance: Double
    @NSManaged public var id: UUID?
    @NSManaged public var number: String?
    @NSManaged public var title: String?
    @NSManaged public var color: Data?
    @NSManaged public var profileParent: Profile?
    @NSManaged public var transactions: NSSet?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedTitle: String {
        title ?? "Unknown account"
    }
    
    public var wrappedColor: Data {
        color ?? Data()
    }
    
    public var wrappedNumber: String {
        number ?? "Unknown number"
    }
    
    public var wrappedTransactions: [Transaction] {
        let set = transactions as? Set<Transaction> ?? []
        return set.sorted {
            $1.wrappedDate < $0.wrappedDate
        }
    }

}

// MARK: Generated accessors for transactions
extension Account {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Account : Identifiable {

}
