//
//  NewProjectViewItem.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct NewProjectViewItem: View {
    var body: some View {
        VStack {
            Image(systemName: "plus")
                .font(.system(size: 100, weight: .ultraLight))
            Text("New Project")
        }
    }
}

struct NewProjectViewItem_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectViewItem()
    }
}
