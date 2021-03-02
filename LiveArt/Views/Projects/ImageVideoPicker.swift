//
//  ImageVideoPicker.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/27/21.
//

import Foundation
import SwiftUI

struct ImageVideoPicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, ImageVideoPickerDelegate {
        func didSelectImage() {
            parent.labelText = "Crop Image"
        }
        
        func didCropImage() {
            parent.labelText = "Select Video"
        }
        
        func didSelectVideo() {
            parent.labelText = "Crop Video"
        }
        func didCancelImagePicking() {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func didCropVideo(imageUUID: String, videoUUID: String) {
            parent.imageUUID = imageUUID
            parent.videoUUID = videoUUID
        }
        let parent: ImageVideoPicker
        
        init(_ parent: ImageVideoPicker) {
            self.parent = parent
        }
    }
    @Environment(\.presentationMode) var presentationMode
    @Binding var labelText: String?
    
    @Binding var imageUUID: String?
    @Binding var videoUUID: String?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageVideoPicker >) -> some UIViewController {
        let imageVideoPickerVC = ImagePickerViewController.init()
        imageVideoPickerVC.delegate = context.coordinator
        return imageVideoPickerVC
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

protocol ImageVideoPickerDelegate {
    func didSelectImage()
    func didCropImage()
    func didSelectVideo()
    func didCancelImagePicking()
    func didCropVideo(imageUUID: String, videoUUID: String)
}
class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VideoCropDelegate, ImageCropDelegate {
    
    var imagePicker: UIImagePickerController?
    var videoPicker: UIImagePickerController?
    var selectedImageUUID: String?
    var selectedVideoUUID: String?
    var imageCropperViewController: ImageCropperViewController?
    var videoCropperViewController: VideoCropperViewController?
    var delegate: ImageVideoPickerDelegate?
    
    override func viewDidLoad() {
    
        imagePicker = UIImagePickerController.init()
        if let picker = imagePicker {
            view.addSubview(picker.view)
            addChild(picker)
            picker.delegate = self
        }
        
        self.view.backgroundColor = .green
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.didCancelImagePicking()
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
                    delegate?.didSelectImage()
                    imageCropperViewController = ImageCropperViewController.init(imageUUID: selectedImageUUID!)
                    imageCropperViewController?.view.frame = self.view.frame
                    if let imageCropper = imageCropperViewController {
                        imageCropper.delegate = self
                        view.addSubview(imageCropper.view)
                        addChild(imageCropper)
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
                videoCropperViewController = VideoCropperViewController.init(videoUUID: videoUrl.lastPathComponent)
                if let videoCropper = videoCropperViewController {
                    delegate?.didSelectVideo()
                    videoCropper.delegate = self
                    self.view.addSubview(videoCropper.view)
                    addChild(videoCropper)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    func didFinishVideoCrop() {
        if let imageId = selectedImageUUID, let videoId = selectedVideoUUID {
            delegate?.didCropVideo(imageUUID: imageId, videoUUID: videoId)
        }
    }
    
    func didCancelVideoCrop() {
        videoCropperViewController?.removeFromParent()
        videoCropperViewController?.view.removeFromSuperview()
        if let picker = imagePicker {
            view.addSubview(picker.view)
            addChild(picker)
            picker.delegate = self
        }
    }
    
    func didFinishImageCrop() {
        delegate?.didCropImage()
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
    
    func didCancelImageCrop() {
        imageCropperViewController?.removeFromParent()
        imageCropperViewController?.view.removeFromSuperview()
        if let picker = imagePicker {
            view.addSubview(picker.view)
            addChild(picker)
            picker.delegate = self
        }
    }
}
