//
//  AccountRow.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import SwiftUI

struct AccountRow: View {
    //MARK: - Properties
    @AppStorage("session") var session: String?
    @State private var showingAlert = false
    
    var title: String
    var balance: Double
    var accountNumber: String
    var name: String
    
    @Binding var selectedAccount: String
        
    //MARK: - body
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("visa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    Text(title)
                        .font(.subheadline)
                    Text(balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.title.weight(.bold))
                }
            } //: HStack
            .padding(.bottom, 40)
            
            Text(accountNumber)
                .font(.title2.weight(.semibold))
                .opacity(0.7)
            
            Text(name)
                .font(.caption)
                .opacity(0.7)
            
        } //: VStack
        .onTapGesture {
            if accountNumber != session {
                showingAlert = true
            }
        }
        .alert("Change Account", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Change") {
                session = accountNumber
                selectedAccount = session ?? ""
            }
        } message: {
            Text("Do you really want to change account to \(accountNumber)?")
        }
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(title: "Current Account", balance: 2310.00, accountNumber: "1234 5678 9012 3456", name: "Leslie Alexander", selectedAccount: .constant("session"))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
