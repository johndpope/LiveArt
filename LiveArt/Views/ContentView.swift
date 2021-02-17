//
//  ContentView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct ContentView: View {
    var model: ProjectsViewModel
    
    @EnvironmentObject var session: SessionStore
    
    init(model: ProjectsViewModel) {
        self.model = model
        UITabBar.appearance().barTintColor = .systemBackground
    }
    
    var body: some View {
        TabView() {
            ProjectsView(projectModel: model)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Projects")
                }
            CameraView()
                .tabItem {
                    Image(systemName: "square.stack.3d.up")
                        .font(.system(size: 150, weight: .bold))
                        .foregroundColor(.red)
                    Text("View")
                }
            AccountView()
                .environmentObject(session)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
        }.onAppear(perform: {
            session.listen()
        })
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ProjectsViewModel())
    }
}
