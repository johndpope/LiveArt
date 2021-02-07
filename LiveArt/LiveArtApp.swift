//
//  LiveArtApp.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

@main
struct LiveArtApp: App {
    var body: some Scene {
        WindowGroup {
            let model = ProjectsViewModel()
            ContentView(model: model)
        }
    }
}