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
        Image.init(uiImage: project.getImage())
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: Project.init(title: "", imageUUID: "", videoUUID: ""))
    }
}
