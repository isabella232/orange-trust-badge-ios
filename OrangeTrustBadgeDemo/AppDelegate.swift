/*
*
* OrangeTrustBadgeDemo
*
* File name:   AppDelegate.swift
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
import PhotosUI
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        // Request Access to MediaLibrary in order to show them in iOS Preferences Panel
        PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus) in })
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (result) -> Void in }

        // Request Access to UserLocation in order to show them in iOS Preferences Panel
        //locationManager.requestAlwaysAuthorization()
        
        // Request microphone access permission
        
        
        // Let's begin OrangeTrustBadge's integration
        let config = TrustBadgeConfig()
        
        
        
        //
        // CONFIGURE DEVICE PERMISSIONS YOUR APP USE
        //
        
        
        
        // Remove the permissions your app do not use from this array below
        //
        config.devicePermissions = [.location,
                                   .contacts,
                                   .photoLibrary,
                                   .media,
                                   .calendar,
                                   .camera,
                                   .reminders,
                                   .bluetoothSharing,
                                   .microphone,
                                   .speechRecognition].map { return PreDefinedElement(type: $0) }


        // Comment this section if your app do not use health permission
        config.devicePermissions.append(PreDefinedElement(type: .health))
        config.isHealfDataUsed = { return true } // Call here your tracking SDK API to get the current Status of user's health data access
        
        // Comment this section if your app do not use homekit
        config.devicePermissions.append(PreDefinedElement(type: .homekit))
        config.isHomeKitUsed = { return true } // Call here your tracking SDK API to get the current Status of user's homekit data access

        // Comment this section if your app do not use motion activity & fitness permission
        config.devicePermissions.append(PreDefinedElement(type: .motionFitness))
        config.isMotionFitnessUsed = { return true } // Call here your tracking SDK API to get the current Status of user's motion activity & fitness data access
        
        
        // comment this section to configure a predifined entry in "Main Permissions" (Here we force the Contact element to be always false and hide the "Go to settings" button)
        if let contactElement = config.elementForType(.contacts).first {
            contactElement.shouldBeAutoConfigured = false
            contactElement.isConfigurable = false
        }

 
        
        //
        // CONFIGURE APPLICATION DATA YOUR APP USE
        //
        
        
        
        // Remove the data your app do not use from this array below
        config.applicationData = [.notifications,
                                  .identity,
                                  .accountInformations,
                                  .dataUsage,
                                  .advertising].map { return PreDefinedElement(type: $0) }

        // enable account credentials usage
        config.isIdentityUsed = {() in return false}

        // adds the optionnal data : .history
        config.applicationData.append(PreDefinedElement(type: .history))
        config.isHistoryUsed = {() in return true }

        // let TrustBadge know the status of UserTracking (DataUsage) and how to update its state
        config.isTrackingEnabled = { 
            // Call here your tracking SDK API to get the current Status
            return UserDefaults.standard.bool(forKey: "TRACKING_KEY")}
        
        // apply a custom behavior when the user toggle the data-usage switch (confirmation popup)
        config.updateTracking = {[unowned self] (toggle) in
            if !toggle.isOn{
                let alert = UIAlertController(title: NSLocalizedString("disable-data-usage-confirmation-title", comment: ""), message: NSLocalizedString("disable-data-usage-confirmation-content", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
                alert.view.tintColor = UIColor.black
                alert.addAction(UIAlertAction(title: NSLocalizedString("disable-data-usage-confirmation-cancel", comment: ""), style: .default, handler: { (action) -> Void in
                    toggle.setOn(true, animated: true)
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("disable-data-usage-confirmation-confirm", comment: ""), style: .default, handler: { (action) -> Void in
                    UserDefaults.standard.set(false, forKey: "TRACKING_KEY")
                    // Call here your desactivation API for tracking
                    toggle.setOn(false, animated: true)
                }))
                let navigationController = self.window!.rootViewController as! UINavigationController
                navigationController.visibleViewController!.present(alert, animated: true, completion: { () -> Void in })
            } else {
                UserDefaults.standard.set(toggle.isOn, forKey: "TRACKING_KEY")
                // Call here your activation API for tracking
            }
        }
 

                
        // uncomment this section to add a new custom entry in "Terms and Conditions"
        //let customTerm = Term(type: .Custom, titleKey: "term-custom-title", contentKey: "term-custom-content")
        //config.terms.append(customTerm)
        
        // fill what's displayed in "Terms and Conditions"
        var terms = [Term]()
        terms.append(Term(type: .video, titleKey: "terms-video-title", contentKey: "terms-video-content"))
        terms.append(Term(type: .text, titleKey: "terms-data-usage-title", contentKey: "terms-data-usage-content"))
        terms.append(Term(type: .text, titleKey: "terms-help-title", contentKey: "terms-help-content"))
        terms.append(Term(type: .text, titleKey: "terms-more-info-title", contentKey: "terms-more-info-content"))
        config.terms = terms
        
        
        //
        // CONFIGURE TrustBadge UI
        //

        
        // uncomment this section to change highlight color used for enabled elements
        //config.highlightColor = UIColor.orangeColor()
        
        // change the status bar style
        config.statusBarStyle = .lightContent
        
        // uncomment this section to change header logo
        //config.headerLogo = UIImage(named:"my-logo")
        
        // uncomment this section to change header text color
        //config.headerTextColor = .red

        
        
        
        // finally, initialize TrustBadgeManager with our configuration
        TrustBadge.with(config)
        
        return true
    }
}

