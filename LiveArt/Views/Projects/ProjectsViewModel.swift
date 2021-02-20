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
        NotificationCenter.default.addObserver(self, selector: #selector(didGetRemoteProject(_:)), name: NSNotification.Name("didGetRemoteProject"), object: nil)
    }
    
    @objc func didGetRemoteProject(_ notification: Notification) {
        if let project = notification.userInfo?["project"] as? Project {
            projectManager.projects.append(project)
        }
        self.objectWillChange.send()
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
