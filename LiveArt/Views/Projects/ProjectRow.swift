//
//  ProjectRow.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct ProjectRow: View {
    var projects: [Project]
    var body: some View {
        HStack {
            HStack {
                if projects.count > 0 {
                    ProjectViewItem(project: projects[0])
                }
                if projects.count > 1 {
                    ProjectViewItem(project: projects[1])
                }
            }
        }
    }
}

struct ProjectRow_Previews: PreviewProvider {
    static var previews: some View {
        ProjectRow(projects: [Project(title: "www"), Project(title: "dddd")])
    }
}
