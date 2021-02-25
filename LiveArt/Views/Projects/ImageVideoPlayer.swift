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
    
    
    init(imageId: String?, videoId: String?) {
        super.init(nibName: nil, bundle: nil)
        self.imageId = imageId
        self.videoId = videoId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let imageUUID = imageId, let imageUrl = ProjectManager.storageDir?.appendingPathComponent(imageUUID), let videoUUID = videoId, let videoUrl = ProjectManager.storageDir?.appendingPathComponent(videoUUID) {
            let player = AVPlayer.init(url: videoUrl)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()
            
//            let image = UIImage.init(contentsOfFile: imageUrl.path)
//            let imageView = UIImageView.init(image: image)
//            imageView.frame = CGRect.init(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0, width: 200.0, height: 200.0)
//            self.view.addSubview(imageView)
        }
    }
    
}
