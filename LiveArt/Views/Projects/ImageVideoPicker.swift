//
//  ImageVideoPicker.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/27/21.
//

import Foundation
import SwiftUI

struct ImageVideoPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject {
        let parent: ImageVideoPicker
        
        init(_ parent: ImageVideoPicker) {
            self.parent = parent
        }
    }
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageVideoPicker >) -> some UIViewController {
        let imageVideoPickerVC = ImagePickerViewController.init()
        return imageVideoPickerVC
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VideoCropDelegate {
    
    var imagePicker: UIImagePickerController?
    var videoPicker: UIImagePickerController?
    var selectedImageUUID: String?
    var selectedVideoUUID: String?
    
    override func viewDidLoad() {
    
        imagePicker = UIImagePickerController.init()
        if let picker = imagePicker {
            view.addSubview(picker.view)
            addChild(picker)
            picker.delegate = self
        }
        
        self.view.backgroundColor = .green
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //handle imagePicking
        picker.removeFromParent()
        picker.view.removeFromSuperview()
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let storageDir = ProjectManager.storageDir?.appendingPathComponent(url.lastPathComponent) {

                self.selectedImageUUID = url.lastPathComponent
                if let jpegData = image.jpegData(compressionQuality: 1.0) {
                    do {
                        try jpegData.write(to: storageDir)
                    } catch {
                        print(error)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                        self.videoPicker = UIImagePickerController.init()
                        self.videoPicker?.allowsEditing = true
                        self.videoPicker?.mediaTypes = ["public.movie"]
                        self.videoPicker?.delegate = self
                        self.videoPicker?.videoMaximumDuration = 30.0
                        self.videoPicker?.view.frame = self.view.frame
                        if let picker = self.videoPicker {
                            self.view.addSubview(picker.view)
                            self.addChild(picker)
                        picker.delegate = self
                    }
                    }
                }
            }
        }

        //handle video picking
        if let videoUrl = info[.mediaURL] as? URL, let storageDir = ProjectManager.storageDir?.appendingPathComponent(videoUrl.lastPathComponent) {
            do {
                self.selectedVideoUUID = videoUrl.lastPathComponent
                try FileManager.default.copyItem(at: videoUrl, to: storageDir)
                //show the video cropper
                let videoCropper = VideoCropperViewController.init(videoUUID: videoUrl.lastPathComponent)
                self.view.addSubview(videoCropper.view)
                addChild(videoCropper)
            } catch {
                print(error)
            }
        }
    }
    
    
    func didFinishCropping() {
        
    }
}