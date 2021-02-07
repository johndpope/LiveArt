//
//  ProjectsView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI




struct ProjectsView: View {
    @ObservedObject var projectModel: ProjectsViewModel
    @State private var isShowingNewProjectView = false
    
    var body: some View {
        let projects = projectModel.getProjects()
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200),spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200),spacing: 12)
                ], spacing: 12, content: {
                    ForEach(0..<projects.count, id: \.self) { num in
                        HStack {
                                NavigationLink(destination: NewProjectView.init(projectsModel: projectModel)) {
                                    let project = projects[num]
                                    ProjectViewItem(project: project)
                                        .shadow(radius: 10)
                                }
                        }
                        .padding()
                    }
                })
            }
            .navigationTitle(Text("My Projects"))
            .navigationBarItems(trailing:
            NavigationLink(destination: NewProjectView.init(projectsModel: projectModel)) {
                HStack {
                    Text("Create")
                    Image(systemName: "plus.square.fill")
                }
            })
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(projectModel: ProjectsViewModel())
    }
}
