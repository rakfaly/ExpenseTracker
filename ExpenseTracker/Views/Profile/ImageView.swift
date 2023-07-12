//
//  ImageView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 12/07/2023.
//

import SwiftUI

struct ImageView: View {
    @State private var showingPhotoSheet = false
    @State private var inputImage: UIImage?
    @Binding var photo: UIImage
    @Binding var image: Image?
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 150, height: 150)
            Text("Insert Photo")
                .foregroundColor(Color.backgroundMain)
            image?
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .scaleEffect(x: 1.5, y: 1.5, anchor: .top)
//                    .offset(CGSize(width: 0, height: 30))
                .clipShape(Circle())
        } //: ZStack
        .padding(.top)
        .onTapGesture {
            showingPhotoSheet = true
        }
        .sheet(isPresented: $showingPhotoSheet) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in
            loadImage()
        }
    }
}

extension ImageView {
    func loadImage() {
        guard let inputImage = inputImage else { return }
        photo = inputImage
        image = Image(uiImage: photo)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(photo: .constant(UIImage()), image: .constant(Image("happy-girl")))
    }
}
