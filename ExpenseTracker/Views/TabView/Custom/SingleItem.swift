//
//  SingleItem.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 06/07/2023.
//

import SwiftUI

struct SingleItem: View {
    var imageName: String
    var text: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: imageName)
                .font(.headline)
            Text(text)
                .font(.footnote)
        }
    }
}

struct SingleItem_Previews: PreviewProvider {
    static var previews: some View {
        SingleItem(imageName: "house.fill", text: "Home")
            .preferredColorScheme(.dark)
    }
}
