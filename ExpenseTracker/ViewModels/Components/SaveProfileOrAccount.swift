//
//  SaveProfileOrAccount.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 16/07/2023.
//
import CoreData
import Foundation

struct SaveProfileOrAccount {
    func saveData(moc: NSManagedObjectContext, profile: Profile, title: TitleAccount, name: String, number: String, balance: Double, date: Date, category: TransactionCategory) {
        let color1 = ColorEnum.allCases.randomElement() ?? .green
        let color2 = ColorEnum.allCases.randomElement() ?? .orange
        let color3 = ColorEnum.allCases.randomElement() ?? .pink
        
        let account = Account(context: moc)
        account.id = UUID()
        account.profileParent = profile
        account.title = title.rawValue
        account.number = number
        account.balance = balance
        DataController.archiveColor(selectedAccount: account, colors: [color1.color, color2.color, color3.color])
        let transaction = Transaction(context: moc)
        transaction.id = UUID()
        transaction.accountParent = account
        transaction.amount = balance
        transaction.wrappedNature = .income
        transaction.date = date
        let categoryParent = Category(context: moc)
        categoryParent.id = UUID()
        transaction.categoryParent = categoryParent
        transaction.categoryParent?.category = category.rawValue
    }
}
