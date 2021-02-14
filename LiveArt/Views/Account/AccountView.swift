//
//  AccountView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/23/21.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var session: SessionStore
    func getUser () {
        session.listen()
    }
    
    func signOut() {
        session.signOut()
    }
    var body: some View {
      Group {
        if (session.session != nil) {
          Text("Hello user!")
            Button(action: signOut) {
                Text("Sign out")
            }
        } else {
            SignInView()
        }
      }.onAppear(perform: getUser)
    }
  }

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(SessionStore())
    }
}
