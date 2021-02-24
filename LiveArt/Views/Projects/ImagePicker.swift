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
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if parent.showingImagePicker {
                if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    if let storageDir = ProjectManager.storageDir?.appendingPathComponent(url.lastPathComponent) {
                        parent.imageUUID = url.lastPathComponent
                        if let jpegData = image.jpegData(compressionQuality: 1.0) {
                            do {
                                try jpegData.write(to: storageDir)
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                }
            } else {
                if let videoUrl = info[.mediaURL] as? URL, let storageDir = ProjectManager.storageDir?.appendingPathComponent(videoUrl.lastPathComponent) {
                    do {
                        try FileManager.default.copyItem(at: videoUrl, to: storageDir)
                        parent.videoUUID = videoUrl.lastPathComponent
                    } catch {
                        print(error)
                    }
                }
            }
            if parent.showingImagePicker {
                parent.showingImagePicker = false
                parent.showingVideoPicker = true
            } else {
                parent.showingImagePicker = false
                parent.showingVideoPicker = false
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var imageUUID: String?
    @Binding var videoUUID: String?
    
    @Binding var showingImagePicker: Bool
    @Binding var showingVideoPicker: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker >) -> some UIViewController {
        let picker = UIImagePickerController()
        
        if showingVideoPicker {
            picker.mediaTypes = ["public.movie"]
        }
        
        picker.delegate = context.coordinator
        picker.videoMaximumDuration = 30.0
        picker.allowsEditing = true
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
