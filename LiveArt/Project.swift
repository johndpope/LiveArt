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
    
    public required init(fromJSON json: JSON) {
        fatalError("init(fromJSON:) has not been implemented")
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
    print(toJsonString())
    }
}
