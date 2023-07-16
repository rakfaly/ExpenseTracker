//
//  NewProfileOrAccountView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import CoreData
import Foundation
import SwiftUI

extension NewProfileOrAccount {
    @MainActor class NewProfileOrAccountViewModel: ObservableObject {
        @Published var image: Image?
        @Published var inputImage: UIImage?
        @Published var showingPhotoSheet = false
                
        func selectAllText() {
            UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
        }
        
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
}
