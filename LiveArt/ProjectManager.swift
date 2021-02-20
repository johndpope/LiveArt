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
            ret = appSupportDir.appendingPathComponent("storage")
        }
        return ret
    }
    
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
