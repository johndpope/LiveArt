//
//  NewProjectView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/24/21.
//

import SwiftUI

struct NewProjectView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var showingImagePicker = false
    @State private var showingVideoEditor = false
    @State private var inputImageUUID: String?
    @State private var projectTitle: String = "New Project"
    @State var showCreateButton = false
    @State private var selectedImage: Image?
    
    var projectsModel: ProjectsViewModel
    var body: some View {
        VStack {
            TextField("My project", text: $projectTitle)
                .cornerRadius(38.5)
                .frame(width: 350, height: 50)
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if selectedImage != nil {
                selectedImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
            } else {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 200, height: 200)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
            }
            
            Button.init("Select Image") {
                showingImagePicker = true
            }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
                ImagePicker.init(imageUUID: self.$inputImageUUID)
            })
            Spacer()
            if showCreateButton {
                Button(action: {
                    if let imageId = inputImageUUID {
                        self.projectsModel.createProject(title: projectTitle, imageUUID: imageId)
                        self.mode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Create")
                        .font(.system(.largeTitle))
                        .frame(width: 350, height: 50)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                })
                .background(Color.blue)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            }
        }
    }
    
    func loadImage() {
        if let image = inputImageUUID, let storageDir = ProjectManager.storageDir {
            let imageUri = storageDir.appendingPathComponent(image)
            if let uiImage = UIImage.init(contentsOfFile: imageUri.path) {
                selectedImage = Image.init(uiImage: uiImage)
                showCreateButton = true
            }
        }
    }
    
}

struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView(projectsModel: ProjectsViewModel())
    }
}
