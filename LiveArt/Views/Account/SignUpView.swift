//
//  SignUpView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/12/21.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false

    @EnvironmentObject var session: SessionStore
    
    func signUp () {
        loading = true
        error = false
        session.signUp(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Create account")
                
                TextField.init("Email", text: $email)
                SecureField.init("Password", text: $password)
                Spacer()
                if (error) {
                    Text("ahhh crap")
                }
                HStack {
                    Button(action: signUp) {
                        Text("Sign up")
                    }
                }
            }
        }
    }
  }

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(SessionStore())
    }
}