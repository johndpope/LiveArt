//
//  NewProjectView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 1/24/21.
//

import SwiftUI
import AVKit

struct NewProjectView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var showingImagePicker = true
    @State private var showingVideoPicker = false
    
    @State private var inputImageUUID: String?
    @State private var inputVideoUUID: String?
    
    @State private var showingVideoEditor = false
    
    @State private var projectTitle: String = ""
    @State private var selectedImage: Image?
    
    @State private var labelText: String?
    
    var projectsModel: ProjectsViewModel
    
    var body: some View {
        VStack {
            
            if inputImageUUID == nil && inputVideoUUID == nil{
//                if let text = labelText {
//                    Text(text)
//                        .font(.system(size: 60))
//                } else {
//                    Text("Select Image")
//                        .font(.system(size: 60))
//                }
//                Spacer()
                ImageVideoPicker(labelText: $labelText, imageUUID: $inputImageUUID, videoUUID: $inputVideoUUID)
                    .edgesIgnoringSafeArea(.all)
            } else {
                ImageVideoPlayer(imageUUID: inputImageUUID, videoUUID: inputVideoUUID)
                NavigationLink(destination: BuyNowView()) {
                Text("Buy Now")
                    .font(.system(.largeTitle))
                    .frame(width: 350, height: 50)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 7)
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
    }
    
    func loadImage() {
        if let image = inputImageUUID, let storageDir = ProjectManager.storageDir {
            let imageUri = storageDir.appendingPathComponent(image)
            if let uiImage = UIImage.init(contentsOfFile: imageUri.path) {
                selectedImage = Image.init(uiImage: uiImage)
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
    func doneButtonClicked(completion: @escaping () -> Void) {
        
    }

}

struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView(projectsModel: ProjectsViewModel())
    }
}
