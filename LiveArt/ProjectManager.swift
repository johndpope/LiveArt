//
//  ProjectManager.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import Foundation
var gProjectManager = ProjectManager()

class ProjectManager {
    var projects = [Project]()
    
    var projectRows: [[Project]] {
        var ret = [[Project]]()
        
        let first = 0
        let last = projects.count - 1
        let interval = 2

        let sequence = stride(from: first, to: last, by: interval)

        for i in sequence {
            var row = [Project]()
            if projects.count > i {
                row.append(projects[i])
            }
            if projects.count > i + 1 {
                row.append(projects[i + 1])
            }
            ret.append(row)
        }
        return ret
    }
}
