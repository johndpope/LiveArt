//
//  VideoEditor.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/10/21.
//

import Foundation
import SwiftUI

struct VideoEditor: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIVideoEditorControllerDelegate {
        let parent: VideoEditor
        
        init(_ parent: VideoEditor) {
            self.parent = parent
        }
        
        func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
            print("break")
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var urlPath: String?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let editor = UIVideoEditorController()
        editor.delegate = context.coordinator
         if let path = urlPath {
            editor.videoPath  = path
        }
        editor.videoMaximumDuration = 15.0
        editor.videoQuality = .typeHigh
        return editor
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
