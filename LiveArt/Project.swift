//
//  Project.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import Foundation
import UIKit
import SwiftyJSON

class Project: JSONableObject, Identifiable {
    @objc dynamic var id: UUID?
    @objc dynamic var title: String?
    var image = UIImage()
    
    init(title: String) {
        self.title = title
        self.id = UUID.init()
        super.init()
    }
    
    required init(fromJSON json: JSON) {
        super.init(fromJSON: json)
    }
    
    override func getAllPropertyMappings() -> [String: String] {
        var mappings = [
            "id": "id",
            "title": "title"
        ]
        for (k, v) in super.getAllPropertyMappings() { mappings[k] = v }
        return mappings
    }
    
    func storeLocal() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        if let projectId = id, let cacheUrl = paths.first?.appendingPathComponent(projectId.description + ".json") {
            try? toJsonString()?.write(to: cacheUrl, atomically: true, encoding: .utf8)
        }
    }
}
