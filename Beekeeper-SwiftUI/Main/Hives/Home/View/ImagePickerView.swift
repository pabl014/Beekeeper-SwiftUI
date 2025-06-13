//
//  ImagePickerView.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 13/06/2025.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 120)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 120)
                    .overlay(
                        VStack {
                            Image(systemName: "photo.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text("Choose photo")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
            }
            
            HStack(spacing: 16) {
                PhotosPicker("Choose photo", selection: $selectedItem, matching: .images)
                    .buttonStyle(.bordered)
                
                if selectedImage != nil {
                    Button("Delete") {
                        selectedImage = nil
                        selectedItem = nil
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
            }
        }
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
}

#Preview {
    
    @Previewable
    @State var previewSelectedImage: UIImage? = UIImage(systemName: "photo")
    
    return ImagePickerView(selectedImage: $previewSelectedImage)
}
