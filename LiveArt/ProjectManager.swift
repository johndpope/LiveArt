//
//  ProjectManager.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import Foundation
import SwiftyJSON
let gProjectManager = ProjectManager()

class ProjectManager {
    
    static var storageDir: URL? {
        var ret: URL?
        if let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let storageDir = appSupportDir.appendingPathComponent("storage")
            if !FileManager.default.fileExists(atPath: storageDir.absoluteString) {
                try? FileManager.default.createDirectory(at: storageDir, withIntermediateDirectories: false, attributes: nil)
            }
            ret = storageDir
        }
        return ret
    }
    
    static var projectDir: URL? {
        var ret: URL?
        if let storageUrl = storageDir {
            let projectsUrl = storageUrl.appendingPathComponent("projects")
            if !FileManager.default.fileExists(atPath: projectsUrl.absoluteString) {
                try? FileManager.default.createDirectory(at: projectsUrl, withIntermediateDirectories: false, attributes: nil)
            }
            ret = projectsUrl
        }
        return ret
    }
    
    var projects = [Project]()
    init() {
        if let projectsDirUrl = ProjectManager.projectDir, let projectFiles = try? FileManager.default.contentsOfDirectory(atPath: projectsDirUrl.path) {
            projectFiles.forEach { (file) in
                if file.contains(".json") {
                    let cachedProjectUrl = projectsDirUrl.appendingPathComponent(file)
                    if let jsonString = try? String.init(contentsOf: cachedProjectUrl) {
                        let json = JSON.init(parseJSON: jsonString)
                        let project = Project.init(fromJSON: json)
                        self.projects.append(project)
                    }
                }
            }
        }
    }
}
