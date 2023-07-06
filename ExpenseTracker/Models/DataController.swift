//
//  DataController.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "ExpenseTracker")
    static var alertTitle: String = "Confirmation"
    static var alertMessage: String = "Data saved with success!"
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    static func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            alertTitle = "Confirmation"
            alertMessage = "Data saved with success!"
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
            alertTitle = "Oops, someyhing went wrong!"
            alertMessage = "Failed to save data!"
        }
    }
}
