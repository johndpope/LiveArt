//
//  SignUpView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/12/21.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = "email"
    @State private var password: String = "password"
    
    var body: some View {
        VStack {
            TextField("email", text: $email)
                .cornerRadius(38.5)
                .frame(width: 350, height: 50)
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
