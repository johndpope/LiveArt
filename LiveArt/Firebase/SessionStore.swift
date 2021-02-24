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
import SwiftyJSON

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
                self.getProjects(userId: userId)
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
    
    func storeProject(imagePath: String, videoPath: String, projectId: String) {
        let storageRef = storage.reference()
        let localImageUrl = URL(string: imagePath)!
        let localVideoUrl = URL(string: videoPath)!
        
        let imageRef = storageRef.child("images/" + projectId + ".jpg")
        let videoRef = storageRef.child("videos/" + projectId + ".mov")

        let uploadImageTask = imageRef.putFile(from: localImageUrl, metadata: nil) { metadata, error in
            if error != nil {
                print("there was error")
            }
        }
        uploadImageTask.resume()
        
        let uploadVideoTask = videoRef.putFile(from: localVideoUrl, metadata: nil) { metadata, error in
            if error != nil {
                print("there was error")
            }
        }
        uploadVideoTask.resume()
        
        if let userId = session?.uid {
//            rootRef.child("user-projects").child(userId + "/" + projectId).setValue(["title": title])
        }
    }
    
    func getProjects(userId: String) {
//        guard let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
//        else { return }
//        let userProjectsRef = rootRef.child("user-projects").child(userId)
//        let storageRef = storage.reference()
//
//        userProjectsRef.getData { (error, snapshot) in
//            if let snapshotDict = snapshot.value as? [String: Any] {
//                snapshotDict.forEach { (imageIdKey, projectInfo) in
//                    let imageRef = storageRef.child("images/" + imageIdKey + ".jpg")
//                    let localFileUrl = cacheUrl.appendingPathComponent(imageIdKey + ".jpg")
//                    imageRef.write(toFile: localFileUrl) { (url, error) in
//                        if let projectInfoDict = projectInfo as? [String: String] {
//                            let json = JSON.init(projectInfoDict)
//                            let project = Project.init(fromJSON: json)
//                            project.id = UUID.init(uuidString: imageIdKey)
//                            project.imageUrlPath = localFileUrl.absoluteString
//                            project.storeLocal()
//                            let didGetProjectNotification: NSNotification.Name = NSNotification.Name("didGetRemoteProject")
//                            NotificationCenter.default.post(name: didGetProjectNotification, object: nil, userInfo: ["project": project])
//                        }
//                    }
//                }
//            }
//        }
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
