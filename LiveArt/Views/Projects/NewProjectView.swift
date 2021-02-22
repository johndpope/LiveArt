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
    @State private var projectTitle: String = ""
    @State var showCreateButton = false
    @State private var selectedImage: Image?
    
    @State private var isUsernameFirstResponder : Bool? = true
    @State private var isPasswordFirstResponder : Bool? =  false
    
    var projectsModel: ProjectsViewModel
    var body: some View {
        VStack {
            CustomTextField(
                placeHolderString: "Project Title",
                text: $projectTitle,
                nextResponder: $isPasswordFirstResponder,
                isResponder: $isUsernameFirstResponder,
                isSecured: false,
                keyboard: .default)
                .cornerRadius(38.5)
                .frame(width: 350, height: 50)
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                .multilineTextAlignment(.center)
                .font(.footnote)
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


struct CustomTextField: UIViewRepresentable {

  class Coordinator: NSObject, UITextFieldDelegate {

     @Binding var text: String
     @Binding var nextResponder : Bool?
     @Binding var isResponder : Bool?
     var parent: CustomTextField?


    init(text: Binding<String>,nextResponder : Binding<Bool?> , isResponder : Binding<Bool?>, parent: CustomTextField) {
       _text = text
       _isResponder = isResponder
       _nextResponder = nextResponder
        self.parent = parent
     }

     func textFieldDidChangeSelection(_ textField: UITextField) {
       text = textField.text ?? ""
     }

     func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.isResponder = true
        }
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
     func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.isResponder = false
            if self.nextResponder != nil {
                self.nextResponder = true
            }
        }
     }
 }
    @Environment(\.presentationMode) var presentationMode
    var placeHolderString: String
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?

    var isSecured : Bool = false
    var keyboard : UIKeyboardType

 func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
     let textField = UITextField(frame: .zero)
     textField.isSecureTextEntry = isSecured
     textField.autocapitalizationType = .none
     textField.autocorrectionType = .no
     textField.keyboardType = keyboard
     textField.textAlignment = .center
     textField.placeholder = placeHolderString
     textField.returnKeyType = .done
     textField.delegate = context.coordinator
     textField.borderStyle = .roundedRect
     return textField
 }

 func makeCoordinator() -> Coordinator {
    return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder, parent: self)
 }

 func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
      uiView.text = text
      if isResponder ?? false {
          uiView.becomeFirstResponder()
      }
 }

}

struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView(projectsModel: ProjectsViewModel())
    }
}
