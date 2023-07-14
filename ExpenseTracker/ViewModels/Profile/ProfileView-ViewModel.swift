//
//  ProfileView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 13/07/2023.
//

import CoreData
import Foundation
import SwiftUI

extension ProfileView {
    @MainActor class ProfileViewModel: ObservableObject {
        @AppStorage("session") private var session: String?
        
        @Published var currentProfile: Profile?
        @Published var name = ""
        @Published var email = ""
        @Published var photo: UIImage = UIImage()
        @Published var image: Image?
        
        @Published var showingAlert = false
        @Published var titleAlert = "Confirmation"
        @Published var messageAlert = "Profile saved successfully!"
        @Published var isSaved = true
        
        func updatePhoto(profile: Profile) {
            if let uiImage = UIImage(data: profile.wrappedPhoto) {
                photo = uiImage
                image = Image(uiImage: photo)
            }
        }
        
        func loadProfile(profiles: FetchedResults<Profile>) async {
            if let profile = profiles.last {
                name = profile.wrappedName
                email = profile.wrappedEmail
                updatePhoto(profile: profile)
                currentProfile = profile
            }
        }
        
        func deleteProfile(profile: Profile?, categories: FetchedResults<Category>, transactions: FetchedResults<Transaction>, moc: NSManagedObjectContext) {
            if let currentProfile = profile {
                moc.delete(currentProfile)
                deleteCategories(categories: categories, moc: moc)
                deleteTransactions(transactions: transactions, moc: moc)
                if session != nil {
                    UserDefaults.standard.removeObject(forKey: "session")
                }
                DataController.save(context: moc)
            }
        }
        
        func deleteCategories(categories: FetchedResults<Category>, moc: NSManagedObjectContext) {
            for category in categories {
                moc.delete(category)
            }
        }
        
        func deleteTransactions(transactions: FetchedResults<Transaction>, moc: NSManagedObjectContext) {
            for transaction in transactions {
                moc.delete(transaction)
            }
        }
        
        func saveProfile(profile: Profile?, moc: NSManagedObjectContext) {
            if let currentProfile = profile {
                currentProfile.name = name
                currentProfile.email = email
                currentProfile.photo = photo.jpegData(compressionQuality: 1.0)
                DataController.save(context: moc)
            }
        }
        
        func isDisabled() -> Bool {
            name.isEmpty || email.isEmpty || currentProfile == nil
        }
    }
}
