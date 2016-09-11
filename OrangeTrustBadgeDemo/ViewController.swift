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

class ViewController: UIViewController {
    
    @IBOutlet weak var versionLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let shortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"){
            versionLabel.text = "version \(shortVersionString)"
        }
    }
    
    @IBAction func startDemo(){
        let storyboard = UIStoryboard(name: "OrangeTrustBadge", bundle: Bundle(for: TrustBadgeManager.self))
        if let viewController = storyboard.instantiateInitialViewController(){
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
