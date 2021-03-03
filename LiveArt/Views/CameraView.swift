//
//  CameraView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/11/21.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        AugmentedCamera.init()
            .navigationBarHidden(true)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
