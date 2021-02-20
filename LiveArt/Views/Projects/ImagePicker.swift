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
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.imageUrlPath = url.path
                if let storageDir = ProjectManager.storageDir?.appendingPathComponent(url.lastPathComponent) {
                    if let jpegData = image.jpegData(compressionQuality: 1.0) {
                        do {
                            try jpegData.write(to: storageDir)
                        } catch {
                            print(error)
                        }
                    }
                    
                }
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
        picker.allowsEditing = true
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
