//
//  ProjectViewItem.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct ProjectViewItem: View {
    var project: Project

    var body: some View {
        VStack {
            Image(uiImage: project.getImage())
                .resizable()
                .scaledToFit()
            Text(project.title ?? "")
        }
    }
}

struct ProjectViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ProjectViewItem(project: Project.init(title: "asdfasdf", imageUUID: ""))
    }
}
