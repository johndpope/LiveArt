//
//  ImagePicker.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/24/21.
//

import SwiftUI
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                parent.imageUrlPath = url.path
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var imageUrlPath: String?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker >) -> some UIViewController {
        let picker = UIImagePickerController()
//        picker.mediaTypes = ["public.movie"]
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
