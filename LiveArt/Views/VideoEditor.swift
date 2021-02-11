//
//  VideoEditor.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/10/21.
//

import Foundation
import SwiftUI

struct VideoEditor: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIVideoEditorControllerDelegate {
        let parent: VideoEditor
        
        init(_ parent: VideoEditor) {
            self.parent = parent
        }
        
        func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var urlPath: String?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let editor = UIVideoEditorController()
        if let path = urlPath {
            editor.videoPath  = path
        }
        return editor
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
