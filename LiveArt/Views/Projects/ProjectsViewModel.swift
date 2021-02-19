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
    
    func createProject(title: String, imageUrlPath: String) {
        self.objectWillChange.send()
        let p = Project(title: title, imageUrlPath: imageUrlPath)
        self.projectManager.projects.append(p)
        p.storeLocal()
        p.storeRemote()
    }
    
    func getProjects() -> [Project] {
        return projectManager.projects
    }
    
}
