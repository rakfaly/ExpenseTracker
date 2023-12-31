//
//  AccountListModalView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 05/07/2023.
//

import SwiftUI

struct AccountListPopOverView: View {
    @AppStorage("session") private var session: String?
    @FetchRequest(sortDescriptors: []) var accounts: FetchedResults<Account>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundMain
            List {
                Section {
                    ForEach(accounts) { account in
                        VStack(alignment: .leading) {
                            Text(account.wrappedTitle)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Text(account.wrappedNumber)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(session == account.wrappedNumber ? .green : .accentColor)
                        }
                        .onTapGesture {
                            withAnimation {
                                session = account.wrappedNumber
                                dismiss()
                            }
                        }
                    }
                    .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
                } header: {
                    Text("Select Account")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}


struct AccountListModalView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListPopOverView()
            .preferredColorScheme(.dark)
    }
}
