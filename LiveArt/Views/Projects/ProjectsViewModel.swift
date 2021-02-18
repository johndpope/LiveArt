//
//  ProjectsViewModel.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import Foundation
import UIKit

class ProjectsViewModel: ObservableObject {
    @Published var projectManager: ProjectManager
    
    init() {
        projectManager = ProjectManager.init()
    }
    
    func createProject(title: String, image: UIImage) {
        self.objectWillChange.send()
        let p = Project(title: title)
        p.image = image
        self.projectManager.projects.append(p)
        p.storeLocal()
    }
    
    func getProjects() -> [Project] {
        let fakeProjects = [Project.init(title: "first proj"), Project.init(title: "second proj"), Project.init(title: "third proj"), Project.init(title: "fourth proj"), Project.init(title: "fifth proj")]
//        return fakeProjects
        return projectManager.projects
    }
    
}
