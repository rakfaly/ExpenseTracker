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
    @Binding var selectedAccount: Account
    @Binding var currentAccountNumber: String
        
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
                    Text(selectedAccount.wrappedTitle)
                        .font(.subheadline)
                    Text(selectedAccount.balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.title.weight(.bold))
                }
            } //: HStack
            .padding(.bottom, 40)
            
            Text(currentAccountNumber)
                .font(.title2.weight(.semibold))
                .opacity(0.7)
            
            Text(selectedAccount.profileParent?.wrappedName ?? "Unknown Name")
                .font(.caption)
                .opacity(0.7)
            
        } //: VStack
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        .background(LinearGradient(gradient: Gradient(colors: DataController.unarchiveData(data: selectedAccount.wrappedColor)), startPoint: .bottomLeading, endPoint: .topTrailing))
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            if selectedAccount.wrappedNumber != session {
                showingAlert = true
            }
        }
        .alert("Change Account", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Change") {
                withAnimation {
                    session = selectedAccount.wrappedNumber
                    currentAccountNumber = session ?? ""
                }
            }
        } message: {
            Text("Do you really want to change account to \(currentAccountNumber)?")
        }
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(selectedAccount: .constant(Account()), currentAccountNumber: .constant(""))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
