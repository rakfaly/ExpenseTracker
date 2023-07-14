//
//  ImageView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Faly RAKOTOMAHARO on 14/07/2023.
//

import Foundation
import SwiftUI

extension ImageView {
    @MainActor class ImageViewModel: ObservableObject {
        @Published var showingPhotoSheet = false
        @Published var inputImage: UIImage?
        
        func loadImage() -> (photo: UIImage, image: Image){
            guard let inputImage = inputImage else { return (UIImage(), Image("")) }
            let photo = inputImage
            let image = Image(uiImage: photo)
            return (photo: photo, image: image)
        }
    }
}
