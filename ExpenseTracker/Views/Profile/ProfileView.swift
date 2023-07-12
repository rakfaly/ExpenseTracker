//
//  Profile.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 28/06/2023.
//

import CoreData
import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var profiles: FetchedResults<Profile>
    @FetchRequest(sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>
    @AppStorage("session") private var session: String?
    @State private var currentProfile: Profile?
    
    @State private var name = ""
    @State private var email = ""
    @State private var photo: UIImage = UIImage()
    @State private var image: Image?
    
    @State private var showingAlert = false
    @State private var titleAlert = "Confirmation"
    @State private var messageAlert = "Profile saved successfully!"
    @State private var isSaved = true
    
    var body: some View {
        VStack {
            ImageView(photo: $photo, image: $image)
            
            Form {
                Section {
                    TextField(text: $name) {
                        Text("Name").foregroundColor(.secondary)
                    }
                } header: {
                    Text("Name").foregroundColor(.backgroundSecondary)
                }
                .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
                Section {
                    TextField(text: $email) {
                        Text("Email")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Email")
                        .foregroundColor(.backgroundSecondary)
                }
                .formSectionStyle(color: Color.backgroundSecondary.opacity(0.3))
            }
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        saveProfile(profile: currentProfile)
                        isSaved = true
                        showingAlert = true
                    } label: {
                        Text("Save")
                    }
                    .disabled(isDisabled())
                    Button {
                        isSaved = false
                        showingAlert = true
                        messageAlert = "Do you really want to delete profile?"
                    } label: {
                        Image(systemName: "trash.circle")
                            .foregroundColor(isDisabled() ? .secondary.opacity(0.3) : .red)
                            .font(.headline)
                    }
                    .disabled(isDisabled())
                }
            }
            .task {
                await loadProfile()
            }
            .alert(titleAlert, isPresented: $showingAlert) {
                if isSaved {
                    Button("OK", role: .cancel) {}
                } else {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        deleteProfile(profile: currentProfile)
                    }
                }
            } message: {
                Text(messageAlert)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundMain)
    } //: body
}

extension ProfileView {
    func loadProfile() async {
        if let profile = profiles.last {
            currentProfile = profile
            name = profile.wrappedName
            email = profile.wrappedEmail
            if let uiImage = UIImage(data: profile.wrappedPhoto) {
                photo = uiImage
                image = Image(uiImage: photo)
            }
        }
    }
    
    func deleteProfile(profile: Profile?) {
        if let currentProfile = profile {
            moc.delete(currentProfile)
            deleteCategories()
            deleteTransactions()
            if session != nil {
                UserDefaults.standard.removeObject(forKey: "session")
            }
            DataController.save(context: moc)
        }
    }
    
    func deleteCategories() {
        for category in categories {
            moc.delete(category)
        }
    }
    
    func deleteTransactions() {
        for transaction in transactions {
            moc.delete(transaction)
        }
    }
    
    func saveProfile(profile: Profile?) {
        if let currentProfile = profile {
            currentProfile.name = name
            currentProfile.email = email
            currentProfile.photo = photo.jpegData(compressionQuality: 1.0)
            DataController.save(context: moc)
        }
    }
    
    func isDisabled() -> Bool {
        name.isEmpty || email.isEmpty || currentProfile == nil
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .preferredColorScheme(.dark)
        }
    }
}
