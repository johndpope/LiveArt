//
//  SignInView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/13/21.
//
import SwiftUI

struct SignInView : View {

    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false

    @EnvironmentObject var session: SessionStore

    func signIn () {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
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
                HStack {
                    Text("Sign in below or")
                    NavigationLink(destination: SignUpView()) {
                        Text("Create Account")
                    }
                }
                
                TextField.init("Email", text: $email)
                SecureField.init("Password", text: $password)
                Spacer()
                if (error) {
                    Text("ahhh crap")
                }
                HStack {
                    Button(action: signIn) {
                        Text("Sign in")
                    }
                }
            }
        }
    }
}
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
