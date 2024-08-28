//
//  ContentView.swift
//  Example
//
//  Created by Ahmed Hussein on 11/08/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button(action: {
                presentViewController()
            }) {
                Text("Present ViewController")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    func presentViewController() {
        // This function finds the root UIViewController and presents the new ViewController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            let viewController = ViewController() // Replace with your UIViewController
            rootViewController.present(viewController, animated: true, completion: nil)
        }
    }
}

#Preview {
    ContentView()
}
