//
//  CameraView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/11/21.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var isShowingDismissButton = false
    
    var body: some View {
        ZStack {
        AugmentedCamera.init(isShowingDismissButton: $isShowingDismissButton)
            .edgesIgnoringSafeArea(.all)
            if isShowingDismissButton {
                VStack {
                    Spacer()
                    Button(action: {
                            self.mode.wrappedValue.dismiss()
                        
                    }) {
                        Text("X")
                            .font(.largeTitle)
                            .frame(width: 70, height: 70)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .shadow(radius: 2)
                }
            }
        }
    }
}
