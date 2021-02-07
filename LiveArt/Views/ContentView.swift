//
//  ContentView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct ContentView: View {
    var model: ProjectsViewModel
    
    var body: some View {
        TabView() {
            ProjectsView(projectModel: model)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Projects")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ProjectsViewModel())
    }
}
