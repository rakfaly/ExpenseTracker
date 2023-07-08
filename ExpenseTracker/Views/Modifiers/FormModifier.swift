//
//  FormModifier.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 03/07/2023.
//

import Foundation
import SwiftUI


struct FormModifier: ViewModifier {
    var color: Color = Color.backgroundSecondary.opacity(0.3)
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(
                Capsule()
                    .fill(color)
                    .padding(.vertical, 5)
            )
            .listRowSeparator(.hidden)
    }
}

extension View {
    func formSectionStyle(color: Color) -> some View {
        modifier(FormModifier(color: color))
    }
}
