//
//  ImageVideoPlayer.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/24/21.
//

import Foundation
import SwiftUI
import AVKit

struct ImageVideoPlayer: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var imageUUID: String?
    @Binding var videoUUID: String?
    
    class Coordinator: NSObject {
        let parent: ImageVideoPlayer
        init(_ parent: ImageVideoPlayer) {
            self.parent = parent
        }
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageVideoPlayer>) -> some UIViewController {
        let vc = PreviewViewController.init(imageId: imageUUID, videoId: videoUUID)
        return vc
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}


class PreviewViewController: UIViewController {
    var imageId: String?
    var videoId: String?
    
    var videoPlayer: AVPlayer?
    var imageView: UIImageView?
    
    var isPlaying = false
    
    
    init(imageId: String?, videoId: String?) {
        super.init(nibName: nil, bundle: nil)
        self.imageId = imageId
        self.videoId = videoId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let vidId = self.videoId {
            let videoCropper = VideoCropperViewController.init(videoUUID: vidId)
            videoCropper.view.frame = self.view.frame
            self.view.addSubview(videoCropper.view)
            addChild(videoCropper)
        }
//        if let imageUUID = imageId, let imageUrl = ProjectManager.storageDir?.appendingPathComponent(imageUUID), let videoUUID = videoId, let videoUrl = ProjectManager.storageDir?.appendingPathComponent(videoUUID) {
//            self.videoPlayer = AVPlayer.init(url: videoUrl)
//            let playerLayer = AVPlayerLayer(player: videoPlayer)
//            playerLayer.frame = self.view.bounds
//            let v = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
//            self.view.addSubview(v)
//            v.layer.addSublayer(playerLayer)
//
//
//            let image = UIImage.init(contentsOfFile: imageUrl.path)
//            imageView = UIImageView.init(image: image)
//            imageView?.frame = CGRect.init(x: 0.0, y: 0.0, width: 250.0, height: 500.0)
//            imageView?.contentMode = .scaleAspectFit
//
//
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//
//            if let iv = imageView {
//                self.view.addSubview(iv)
//                iv.isUserInteractionEnabled = true
//                iv.addGestureRecognizer(tapGestureRecognizer)
//            }
//        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if isPlaying {
            isPlaying = false
            videoPlayer?.pause()
        } else {
            isPlaying = true
            videoPlayer?.play()
        }
    }
}
