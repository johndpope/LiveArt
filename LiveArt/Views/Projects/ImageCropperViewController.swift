//
//  ImageCropperViewController.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/27/21.
//

import Foundation
import UIKit
import TOCropViewController

protocol ImageCropDelegate {
    func didFinishImageCrop()
    func didCancelImageCrop()
}
class ImageCropperViewController: UIViewController, TOCropViewControllerDelegate {
    
    var imageUUID: String?
    var imageCropper: TOCropViewController?
    var delegate: ImageCropDelegate?
    
    init(imageUUID: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageUUID = imageUUID
    }
    
    override func viewDidLoad() {
        if let imageId = imageUUID, let imageUrl = ProjectManager.storageDir?.appendingPathComponent(imageId) {
            if let image = UIImage.init(contentsOfFile: imageUrl.path) {
                self.imageCropper = TOCropViewController.init(image: image)
                if let cropper = self.imageCropper {
                    cropper.allowedAspectRatios = [NSNumber.init(value: TOCropViewControllerAspectRatioPreset.preset7x5.rawValue)]
                    cropper.aspectRatioLockEnabled = true
                    cropper.aspectRatioPickerButtonHidden = true
                    cropper.view.frame = self.view.frame
                    cropper.delegate = self
                    addChild(cropper)
                    view.addSubview(cropper.view)
                }
            }
        }
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        if let imageId = imageUUID, let storageDir = ProjectManager.storageDir?.appendingPathComponent(imageId) {
            do {
                try image.jpegData(compressionQuality: 1.0)?.write(to: storageDir)
            } catch {
                print(error)
            }
        }
        delegate?.didFinishImageCrop()
    }
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        delegate?.didCancelImageCrop()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
