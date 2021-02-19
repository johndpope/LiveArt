//
//  SessionStore.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 2/13/21.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import Combine

let gSessionStore = SessionStore()
class SessionStore : ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    let rootRef = Database.database().reference()
    let storage = Storage.storage()

    func listen () {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                let userId = user.uid
                let userRef = self.rootRef.child("users").child(userId)
                userRef.getData { (error, snapshot) in
                    if let userData = snapshot.value as? [String: String] {
                        self.session = User(
                            uid: user.uid,
                            email: user.email,
                            firstName: userData["firstname"],
                            lastName: userData["lastname"]
                        )
                        DispatchQueue.main.async {
                            self.objectWillChange.send()
                        }
                    }
                }
            } else {
                // if we don't have a user, set our session to nil
                self.session = nil
            }
        }
    }

    func signUp( email: String, password: String, handler: @escaping AuthDataResultCallback ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        self.objectWillChange.send()
    }

    func signIn( email: String, password: String, handler: @escaping AuthDataResultCallback ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func createUser(firstName: String, lastName: String, email: String, uid: String) {
        rootRef.child("users").child(uid).setValue(["firstname": firstName, "lastname": lastName, "email": email])
    }
    
    func storeProject(imagePath: String) {
        let storageRef = storage.reference()
        let localFile = URL(string: "file://" + imagePath)!
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/firstImage.jpg")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
        uploadTask.resume()
    }

    func signOut () -> Bool {
        self.objectWillChange.send()
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

class User {
    var uid: String
    var email: String?
    var firstName: String?
    var lastName: String?

    init(uid: String, email: String?, firstName: String?, lastName: String?) {
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
