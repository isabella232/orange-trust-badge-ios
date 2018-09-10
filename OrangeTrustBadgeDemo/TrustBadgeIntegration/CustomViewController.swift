//
//  CustomViewController.swift
//  ESSTrustBadge_iOS
//
//  Created by Marc Beaudoin on 25/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
import OrangeTrustBadge

/// A custom view controller added to trusbadge UI
class CustomViewController: UIViewController, TrustBadgeDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let splitViewController = self.splitViewController {
            navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
            navigationItem.leftItemsSupplementBackButton = true
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
        }
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: TrustBadgeDelegate
// Implement this delegate only if your app should display a custom viewcontroller
extension ViewController: TrustBadgeDelegate {
    
    func shouldDisplayCustomViewController() -> Bool {
        return true
    }
    
    func viewController(at indexPath: IndexPath) -> UIViewController {
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "CustomEntry") as! UINavigationController
        navigationController.viewControllers.first?.title = NSLocalizedString("landing-custom-title", comment: "custom view controller title")
        return navigationController
    }
}

