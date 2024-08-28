//
//  ViewController.swift
//  Homes&
//
//  Created by Mostafa El_sayed on 11/08/2024.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate your ViewModel
        let viewModel = HomeServicesViewModel(
            servicesUseCase: HomeServicesUseCase(
                numberOfItems: "20"
            )
        )
        
        // Create the SwiftUI view using your ViewModel
        let homeServicesView = HomeServicesView(viewModel: viewModel)
        
        // Embed the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: homeServicesView)
        
        // Add the hostingController as a child of your ViewController
        addChild(hostingController)
        
        // Add the SwiftUI view to your ViewController's view hierarchy
        view.addSubview(hostingController.view)
        
        // Set up constraints or frame for the hostingController's view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Notify the hostingController that it has been moved to the current view controller
        hostingController.didMove(toParent: self)
    }


}

