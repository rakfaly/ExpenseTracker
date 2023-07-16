//
//  AddProfile-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import CoreData
import Foundation
import SwiftUI

extension AddProfile {
    @MainActor class AddProfileViewModel: ObservableObject {
        @Published var uiImage: UIImage = UIImage()
        @Published var name = ""
        @Published var email = ""
        @Published var title: TitleAccount = .currentAccount
        @Published var number = ""
        @Published var balance = 0.0
        @Published var color = Data()
        @Published var category: TransactionCategory = .salary
        @Published var date = Date.now
            
        @Published var showingAlert = false
        @Published var messageAlert = ""
        @Published var titleAlert = ""
        
        @Published var saveAccount = SaveProfileOrAccount()
        
        var isDisabled: Bool {
            name.isEmpty || email.isEmpty || number.isEmpty
        }
        
        func selectAllText() {
            UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
        }
        
        func saveSession(account: String) {
            UserDefaults.standard.set(account, forKey: "session")
        }
        
        func saveData(moc: NSManagedObjectContext) {
            let profile = Profile(context: moc)
            profile.id = UUID()
            profile.name = name
            profile.photo = uiImage.jpegData(compressionQuality: 0.8)
            profile.email = email
            
            saveAccount.saveData(moc: moc, profile: profile, title: title, name: name, number: number, balance: balance, date: date, category: category)
            
            do {
                try moc.save()
//                saveSession(account: account.wrappedNumber)
                saveSession(account: number)
            } catch {
                print("Failed to save data: \(error.localizedDescription)")
                showingAlert = true
                titleAlert = "Something went wrong!"
                messageAlert = AlertMessage.saveFailed.rawValue
            }
        }
    }
}
