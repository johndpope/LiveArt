//
//  Project.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import Foundation
import UIKit
import SwiftyJSON

struct Project: Hashable, Identifiable {
    var id: UUID?
    
    init(title: String) {
        self.title = title
        self.id = UUID.init()
    }
    var title = "My Project"
    var image = UIImage()
}
