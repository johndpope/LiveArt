//
//  BuyNowView.swift
//  LiveArt
//
//  Created by Caleb Mitcler on 3/3/21.
//

import SwiftUI
import Foundation
import Stripe

struct BuyNowView: View {
    var body: some View {
        Text("Buy Now")
    }
}

struct BuyNowView_Previews: PreviewProvider {
    static var previews: some View {
        BuyNowView()
    }
}


struct BuyNow: UIViewControllerRepresentable {
    class Coordinator: NSObject {
        
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIViewController.init()
        return vc
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator.init()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class BuyNowViewController: UIViewController {
    
}
