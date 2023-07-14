//
//  AddProfile.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import CoreData
import SwiftUI

struct AddProfile: View {
    //MARK: - Properties    
    @Environment(\.managedObjectContext) var moc
    @StateObject private var addProfileViewModel = AddProfileViewModel()
    @FocusState var isFocused: NewProfileOrAccount.FocusedField?
            
    //MARK: - Body
    var body: some View {
        NewProfileOrAccount(name: $addProfileViewModel.name, email: $addProfileViewModel.email, photo: $addProfileViewModel.uiImage, title: $addProfileViewModel.title, number: $addProfileViewModel.number, balance: $addProfileViewModel.balance, category: $addProfileViewModel.category, date: $addProfileViewModel.date, isFocused: _isFocused)
        .navigationTitle("Add Profile")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundSecondary)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AppTabView()
                } label: {
                    Text("Save")
                } .simultaneousGesture(TapGesture().onEnded({ _ in
                    addProfileViewModel.saveData(moc: moc)
                }))
                .padding(.trailing)
                .disabled(addProfileViewModel.isDisabled)
            }
            
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            
            if isFocused == .decimal {
                ToolbarItem(placement: .keyboard) {
                    Button {
                        isFocused = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
        .alert(addProfileViewModel.titleAlert, isPresented: $addProfileViewModel.showingAlert) {
            Button("OK") {}
        } message: {
            Text(addProfileViewModel.messageAlert)
        }
    }
}


//MARK: - Preview
struct AddProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddProfile()
                .preferredColorScheme(.dark)
        }
    }
}
