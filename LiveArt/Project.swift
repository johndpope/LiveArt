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
    @objc dynamic var imageUUID: String?
    
    init(title: String, imageUUID: String) {
        self.title = title
        self.imageUUID = imageUUID
        self.id = UUID.init()
        super.init()
    }
    
    required init(fromJSON json: JSON) {
        super.init(fromJSON: json)
    }
    
    override func getAllPropertyMappings() -> [String: String] {
        var mappings = [
            "id": "id",
            "title": "title",
            "image_uuid": "imageUUID"
        ]
        
        for (k, v) in super.getAllPropertyMappings() { mappings[k] = v }
        return mappings
    }
    
    func getImage() -> UIImage {
        var ret = UIImage.init()
        if let imageId = imageUUID, let imageUrl = ProjectManager.storageDir?.appendingPathComponent(imageId) {
            if let image = UIImage.init(contentsOfFile: imageUrl.path) {
                ret = image
            }
        }
        return ret
    }
    
    func storeLocal() {
        if let projectsDirUrl = ProjectManager.projectDir {
            if let projectId = id {
                let cacheUrl = projectsDirUrl.appendingPathComponent(projectId.description + ".json")
                try? toJsonString()?.write(to: cacheUrl, atomically: true, encoding: .utf8)
            }
        }
    }
    
    func storeRemote() {
        if let urlPath = imageUUID, let url = URL.init(string: urlPath), let idString = id?.description, let projTitle = title {
            let imagePath = NSTemporaryDirectory() + "/" + url.lastPathComponent
            gSessionStore.storeProject(imagePath: imagePath, projectId: idString, title: projTitle)
        }
    }
}
