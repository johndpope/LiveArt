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
    @objc dynamic var imageUrlPath: String?
    
    init(title: String, imageUrlPath: String) {
        self.title = title
        self.imageUrlPath = imageUrlPath
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
            "image_url_path": "imageUrlPath"
        ]
        
        for (k, v) in super.getAllPropertyMappings() { mappings[k] = v }
        return mappings
    }
    
    func getImage() -> UIImage {
        var ret = UIImage.init()
        if let urlPath = imageUrlPath, let url = URL.init(string: urlPath) {
            let imagePath = NSTemporaryDirectory() + "/" + url.lastPathComponent
            if let image = UIImage.init(contentsOfFile: imagePath) {
                ret = image
            }
        }
        return ret
    }
    
    func storeLocal() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        if let projectId = id, let cacheUrl = paths.first?.appendingPathComponent(projectId.description + ".json") {
            try? toJsonString()?.write(to: cacheUrl, atomically: true, encoding: .utf8)
        }
    }
    
    func storeRemote() {
        if let urlPath = imageUrlPath, let url = URL.init(string: urlPath), let idString = id?.description {
            let imagePath = NSTemporaryDirectory() + "/" + url.lastPathComponent
            gSessionStore.storeProject(imagePath: imagePath, projectId: idString)
        }
    }
}
