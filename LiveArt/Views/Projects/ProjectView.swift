//
//  ProjectView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 3/2/21.
//

import SwiftUI

struct ProjectView: View {
    var project: Project
    var body: some View {
        ImageVideoPlayer.init(imageUUID: project.imageUUID, videoUUID: project.videoUUID)
        
        NavigationLink(destination: BuyNowView()) {
        Text("Buy Now")
            .font(.system(.largeTitle))
            .frame(width: 350, height: 50)
            .foregroundColor(Color.white)
            .padding(.bottom, 7)
            .background(Color.blue)
            .cornerRadius(38.5)
            .padding()
            .shadow(color: Color.black.opacity(0.3),
                    radius: 3,
                    x: 3,
                    y: 3)
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: Project.init(title: "", imageUUID: "", videoUUID: ""))
    }
}
