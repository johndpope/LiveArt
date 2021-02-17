//
//  AccountView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var session: SessionStore
    
    func signOut() {
        session.signOut()
    }
    
    var body: some View {
        NavigationView {
              if (session.session != nil) {
                VStack {
                    Text("Hello \(session.session?.firstName ?? "")!")
                      Button(action: signOut) {
                          Text("Sign out")
                      }
                }
              } else {
                SignInView(session: session)
              }
        }
    }
  }

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(SessionStore())
    }
}
