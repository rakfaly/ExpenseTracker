//
//  HeaderAddCardView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 01/07/2023.
//

import SwiftUI

struct HeaderAddCardView: View {
    let image: String
    let foregroundColor: Color
    let title: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: image)
                .font(.title)
                .foregroundColor(foregroundColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(foregroundColor)
        }
        .frame(width: 150, height: 100)
        .background(backgroundColor.opacity(0.2))
        .cornerRadius(20)
    }
}

struct HeaderAddCardView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderAddCardView(image: "square.and.arrow.down.fill", foregroundColor: .buttonPurple, title: "Add Income", backgroundColor: .backgroundSecondary)
            .preferredColorScheme(.dark)
    }
}
