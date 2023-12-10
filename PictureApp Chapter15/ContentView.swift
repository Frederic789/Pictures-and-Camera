//
//  ContentView.swift
//  PictureApp Chapter15
//
//  Created by Student Account on 12/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showImagePicker: Bool = false
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
            }
            
            Button("Choose from Photo Library") {
                self.imageSource = .photoLibrary
                self.showImagePicker = true
            }
            .padding()
            
            Button("Take Photo") {
                self.imageSource = .camera
                self.showImagePicker = true
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$selectedImage, sourceType: self.imageSource)
        }
    }

        struct ImagePicker: UIViewControllerRepresentable {
            @Environment(\.presentationMode) var presentationMode
            @Binding var image: UIImage?
            var sourceType: UIImagePickerController.SourceType

            func makeUIViewController(context: Context) -> UIImagePickerController {
                let picker = UIImagePickerController()
                picker.sourceType = sourceType
                picker.delegate = context.coordinator
                return picker
            }

            func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

            func makeCoordinator() -> Coordinator {
                Coordinator(self)
            }

            class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                let parent: ImagePicker

                init(_ parent: ImagePicker) {
                    self.parent = parent
                }

                func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    if let image = info[.originalImage] as? UIImage {
                        parent.image = image
                    }

                    parent.presentationMode.wrappedValue.dismiss()
                }

                func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                    parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }

    }



