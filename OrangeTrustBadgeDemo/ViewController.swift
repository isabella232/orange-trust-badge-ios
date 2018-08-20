/*
*
* OrangeTrustBadgeDemo
*
* File name:   ViewController.swift
* Created:     15/12/2015
* Created by:  Romain BIARD
*
* Copyright 2015 Orange
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


import UIKit
import OrangeTrustBadge

class ViewController: UIViewController  {
    
    @IBOutlet weak var versionLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let shortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"){
            versionLabel.text = "version \(shortVersionString)"
        }
        // The delegate that will manage an eventual CustomViewController
        // Set this property if your app should display a custom viewcontroller
        TrustBadge.shared.delegate = self
    }
    
    @IBAction func startDemo(){
        let storyboard = UIStoryboard(name: "OrangeTrustBadge", bundle: Bundle(for: TrustBadge.self))
        
        // Uncomment those line if you want TrustBage to be presented modally
//        if let viewController = storyboard.instantiateInitialViewController(){
//            self.present(viewController, animated: true, completion: nil)
//        }
        
        // Uncomment those line if you want TrustBage to be pushed
        let viewController = storyboard.instantiateViewController(withIdentifier: "LandingController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: TrustBadgeDelegate
// Implement this delegate if your app should display a custom viewcontroller
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

