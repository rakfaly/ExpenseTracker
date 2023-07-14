//
//  Profile.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import CoreData
import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var profiles: FetchedResults<Profile>
    @FetchRequest(sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>
    
    @FocusState private var isFocused
    
    var body: some View {
        VStack {
            ImageView(photo: $profileViewModel.photo, image: $profileViewModel.image)
            
            Form {
                Section {
                    TextField(text: $profileViewModel.name) {
                        Text("Name").foregroundColor(.secondary)
                    }
                    .focused($isFocused)
                } header: {
                    Text("Name").foregroundColor(.backgroundSecondary)
                }
                .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
                Section {
                    TextField(text: $profileViewModel.email) {
                        Text("Email")
                            .foregroundColor(.secondary)
                    }
                    .focused($isFocused)
                } header: {
                    Text("Email")
                        .foregroundColor(.backgroundSecondary)
                }
                .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
            }
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        profileViewModel.saveProfile(profile: profileViewModel.currentProfile, moc: moc)
                        profileViewModel.isSaved = true
                        profileViewModel.showingAlert = true
                        isFocused = false
                    } label: {
                        Text("Save")
                    }
                    .disabled(profileViewModel.isDisabled())
                    Button {
                        profileViewModel.isSaved = false
                        profileViewModel.showingAlert = true
                        profileViewModel.messageAlert = "Do you really want to delete profile?"
                        isFocused = false
                    } label: {
                        Image(systemName: "trash.circle")
                            .foregroundColor(profileViewModel.isDisabled() ? .secondary.opacity(0.3) : .red)
                            .font(.headline)
                    }
                    .disabled(profileViewModel.isDisabled())
                }
            }
            .task {
                await profileViewModel.loadProfile(profiles: profiles)
            }
            .alert(profileViewModel.titleAlert, isPresented: $profileViewModel.showingAlert) {
                if profileViewModel.isSaved {
                    Button("OK", role: .cancel) {}
                } else {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        profileViewModel.deleteProfile(profile: profileViewModel.currentProfile, categories: categories, transactions: transactions, moc: moc)
                    }
                }
            } message: {
                Text(profileViewModel.messageAlert)
            }
        } // VStack
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundMain)
    } //: body
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .preferredColorScheme(.dark)
        }
    }
}
