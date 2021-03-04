//
//  ProjectsView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct ProjectsView: View {
    @ObservedObject var projectModel: ProjectsViewModel
    @State private var showingDetail = false

    var body: some View {
        let projects = projectModel.getProjects()
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(minimum: 100, maximum: 200),spacing: 12),
                        GridItem(.flexible(minimum: 100, maximum: 200),spacing: 12)
                    ], spacing: 12, content: {
                        ForEach(0..<projects.count, id: \.self) { num in
                            HStack {
                                let project = projects[num]
                                    NavigationLink(destination: ProjectView(project: project)) {
                                        ProjectViewItem(project: project)
                                            .shadow(radius: 10)
                                    }
                            }
                            .padding()
                        }
                    })
                }
                VStack {
                    Spacer()
                    Button("Present!") {
                        showingDetail.toggle()
                    }
                    .fullScreenCover(isPresented: $showingDetail, content: CameraView.init)
//                    Button("Show Detail") {
//                        showingDetail.toggle()
//                    }
//                    .fullScreenCover(isPresented: $isPresented, content: CameraView.init)

                    
//                    NavigationLink(destination: CameraView()) {
//                        Image(systemName: "square.stack.3d.up")
//                            .font(.largeTitle)
//                            .frame(width: 70, height: 70)
//                            .background(Color.blue)
//                            .clipShape(Circle())
//                            .foregroundColor(.white)
//                    }
//                    .padding()
//                    .shadow(radius: 2)
                }
            }
            .navigationTitle(Text("My Projects"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink.init(destination: NewProjectView.init(projectsModel: projectModel)) {
                        Text("Create")
                        Image(systemName: "plus.square.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink.init(destination: AccountView.init()) {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(projectModel: ProjectsViewModel())
    }
}
