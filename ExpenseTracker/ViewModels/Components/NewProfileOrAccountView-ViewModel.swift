//
//  NewProfileOrAccountView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

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
    }
}
