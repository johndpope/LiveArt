//
//  ProjectManager.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import Foundation
import SwiftyJSON
var gProjectManager = ProjectManager()

class ProjectManager {
    var projects = [Project]()
    init() {
        if let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            if let cachedFiles = try? FileManager.default.contentsOfDirectory(atPath: cacheUrl.path) {
                cachedFiles.forEach { (file) in
                    if file.contains(".json") {
                        let cachedProjectUrl = cacheUrl.appendingPathComponent(file)
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
}
