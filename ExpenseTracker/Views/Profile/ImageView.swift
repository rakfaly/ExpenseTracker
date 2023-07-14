//
//  ImageView.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 12/07/2023.
//

import SwiftUI

struct ImageView: View {
    @StateObject private var imageViewModel = ImageViewModel()
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
            imageViewModel.showingPhotoSheet = true
        }
        .sheet(isPresented: $imageViewModel.showingPhotoSheet) {
            ImagePicker(image: $imageViewModel.inputImage)
        }
        .onChange(of: imageViewModel.inputImage) { _ in
            (photo: photo, image: image) = imageViewModel.loadImage()
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(photo: .constant(UIImage()), image: .constant(Image("happy-girl")))
    }
}
