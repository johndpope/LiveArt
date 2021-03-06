//
//  LiveArtApp.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI
import Firebase
import FirebaseFunctions
import Stripe

@main
struct LiveArtApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            let model = ProjectsViewModel()
            ContentView(model: model)
                .environmentObject(gSessionStore)
        }
    }
}
