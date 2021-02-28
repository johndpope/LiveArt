//
//  VideoCropperViewController.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/27/21.
//

import Foundation
import UIKit
import PryntTrimmerView
import AVKit

protocol VideoCropDelegate {
    func didFinishVideoCrop()
    func didCancelVideoCrop()
}
class VideoCropperViewController: UIViewController {
    var videoUUID: String?
    var videoAsset: AVAsset?
    var delegate: VideoCropDelegate?
    @IBOutlet var videoCropView: VideoCropView!
    
    init(videoUUID: String) {
        super.init(nibName: "VideoCropperViewController", bundle: Bundle.main)
        self.videoUUID = videoUUID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        videoCropView.setAspectRatio(CGSize(width: 5, height: 7), animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
            if let videoId = self.videoUUID, let videoUrl = ProjectManager.storageDir?.appendingPathComponent(videoId) {
                self.videoAsset = AVAsset.init(url: videoUrl)
                self.videoCropView.asset = self.videoAsset
            }
        }
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        if let asset = videoCropView.asset {
            let selectedTime = CMTime.init(value: CMTimeValue(0.0), timescale: .zero)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.requestedTimeToleranceBefore = CMTime.zero
            generator.requestedTimeToleranceAfter = CMTime.zero
            generator.appliesPreferredTrackTransform = true
            var actualTime = CMTime.zero
            let image = try? generator.copyCGImage(at: selectedTime, actualTime: &actualTime)
            if let image = image {

                let selectedImage = UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .up)
                if let croppedImage = selectedImage.crop(in: videoCropView.getImageCropFrame()) {
                    UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
                }
            }

            try? prepareAssetComposition()
            delegate?.didFinishVideoCrop()
        }
    }
    
    func prepareAssetComposition() throws {

        guard let asset = videoCropView.asset, let videoTrack = asset.tracks(withMediaType: AVMediaType.video).first else {
            return
        }
        
        let assetComposition = AVMutableComposition()
        let frame1Time = CMTime(seconds: asset.duration.seconds, preferredTimescale: asset.duration.timescale)
        
        let trackTimeRange = CMTimeRangeMake(start: .zero, duration: frame1Time)

        guard let videoCompositionTrack = assetComposition.addMutableTrack(withMediaType: .video,
                                                                           preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return
        }

        try videoCompositionTrack.insertTimeRange(trackTimeRange, of: videoTrack, at: CMTime.zero)

        if let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first {
            let audioCompositionTrack = assetComposition.addMutableTrack(withMediaType: AVMediaType.audio,
                                                                      preferredTrackID: kCMPersistentTrackID_Invalid)
            try audioCompositionTrack?.insertTimeRange(trackTimeRange, of: audioTrack, at: CMTime.zero)
        }

        //1. Create the instructions
        let mainInstructions = AVMutableVideoCompositionInstruction()
        mainInstructions.timeRange = CMTimeRangeMake(start: .zero, duration: asset.duration)

        //2 add the layer instructions
        let layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: videoCompositionTrack)

        let renderSize = CGSize(width: 16 * videoCropView.aspectRatio.width * 18,
                                height: 16 * videoCropView.aspectRatio.height * 18)
        let transform = getTransform(for: videoTrack)

        layerInstructions.setTransform(transform, at: CMTime.zero)
        layerInstructions.setOpacity(1.0, at: CMTime.zero)
        mainInstructions.layerInstructions = [layerInstructions]

        //3 Create the main composition and add the instructions

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = renderSize
        videoComposition.instructions = [mainInstructions]
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale:     30)

        let url = URL(fileURLWithPath: "\(NSTemporaryDirectory())TrimmedMovie.mp4")
        try? FileManager.default.removeItem(at: url)

        let exportSession = AVAssetExportSession(asset: assetComposition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.videoComposition = videoComposition
        exportSession?.outputURL = url
        exportSession?.exportAsynchronously(completionHandler: {

            DispatchQueue.main.async {

                if let url = exportSession?.outputURL, exportSession?.status == .completed {
                    UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
                } else {
                    let error = exportSession?.error
                    print("error exporting video \(String(describing: error))")
                }
            }
        })
    }
    
    private func getTransform(for videoTrack: AVAssetTrack) -> CGAffineTransform {

        let renderSize = CGSize(width: 16 * videoCropView.aspectRatio.width * 18,
                                height: 16 * videoCropView.aspectRatio.height * 18)
        let cropFrame = videoCropView.getImageCropFrame()
        let renderScale = renderSize.width / cropFrame.width
        let offset = CGPoint(x: -cropFrame.origin.x, y: -cropFrame.origin.y)
        let rotation = atan2(videoTrack.preferredTransform.b, videoTrack.preferredTransform.a)

        var rotationOffset = CGPoint(x: 0, y: 0)

        if videoTrack.preferredTransform.b == -1.0 {
            rotationOffset.y = videoTrack.naturalSize.width
        } else if videoTrack.preferredTransform.c == -1.0 {
            rotationOffset.x = videoTrack.naturalSize.height
        } else if videoTrack.preferredTransform.a == -1.0 {
            rotationOffset.x = videoTrack.naturalSize.width
            rotationOffset.y = videoTrack.naturalSize.height
        }

        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: renderScale, y: renderScale)
        transform = transform.translatedBy(x: offset.x + rotationOffset.x, y: offset.y + rotationOffset.y)
        transform = transform.rotated(by: rotation)

        print("track size \(videoTrack.naturalSize)")
        print("preferred Transform = \(videoTrack.preferredTransform)")
        print("rotation angle \(rotation)")
        print("rotation offset \(rotationOffset)")
        print("actual Transform = \(transform)")
        return transform
    }
}
extension UIImage {

    func crop(in frame: CGRect) -> UIImage? {

        if let croppedImage = self.cgImage?.cropping(to: frame) {
            return UIImage(cgImage: croppedImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}

