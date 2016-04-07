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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // Request Access to MediaLibrary in order to show them in iOS Preferences Panel
        PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus) in })
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (result) -> Void in }
        
        // Let's begin OrangeTrustBadge's integration
        let config = TrustBadgeConfig()
        
        // uncomment this section to let TrustBadge know the status of UserTracking (DataUsage) and how to update its state
        config.isTrackingEnabled = {() in
            // Call here your tracking SDK API to get the current Status
            return NSUserDefaults.standardUserDefaults().boolForKey("TRACKING_KEY")}
        
        // enable identity usage
        //config.isIdentityUsed = {() in return true}
        
        // uncomment this section to apply a custom behavior when the user toggle the data-usage switch (confirmation popup)
        
        config.updateTracking = {[unowned self] (toggle) in
            if !toggle.on{
                let alert = UIAlertController(title: NSLocalizedString("disable-data-usage-confirmation-title", comment: ""), message: NSLocalizedString("disable-data-usage-confirmation-content", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                alert.view.tintColor = UIColor.blackColor()
                alert.addAction(UIAlertAction(title: NSLocalizedString("disable-data-usage-confirmation-cancel", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    toggle.setOn(true, animated: true)
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("disable-data-usage-confirmation-confirm", comment: ""), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "TRACKING_KEY")
                    // Call here your desactivation API for tracking
                    toggle.setOn(false, animated: true)
                }))
                let navigationController = self.window!.rootViewController as! UINavigationController
                navigationController.visibleViewController!.presentViewController(alert, animated: true, completion: { () -> Void in })
            } else {
                NSUserDefaults.standardUserDefaults().setBool(toggle.on, forKey: "TRACKING_KEY")
                // Call here your activation API for tracking
            }
        }
        
        // uncomment this section to change highlight color used for enabled elements
        //config.highlightColor = UIColor.orangeColor()
        
        // uncomment this section to change the status bar style
        config.statusBarStyle = .LightContent
        
        // uncomment this section to change the rating
        config.rating = Rating(type: .Level12)
        
        // uncomment this section to add a new custom entry in "Other Permissions"
        /**
        let myCustomElement = CustomElement(nameKey: "custom-permission-name-key", descriptionKey: "custom-permission-description-key", statusEnabledIconName: "permission-credit-card-enabled-icon", statusDisabledIconName: "permission-credit-card-disabled-icon")
        myCustomElement.isConfigurable = false
        myCustomElement.statusClosure = {() in return true}
        config.otherElements.append(myCustomElement)
        */
        
        // uncomment this section to configure a predifined entry in "Main Permissions" (Here we force the Contact element to be always false and hide the "Go to settings" button)
        if config.elementForType(.Contacts).count == 1 {
            let contactElement = config.elementForType(.Contacts).first!
            contactElement.shouldBeAutoConfigured = false
            contactElement.isConfigurable = false
        }
        
        // uncomment this section to add a new Calendar entry in "Other Permissions"
        /**
        let calendarElement = PreDefinedElement(type: .Calendar)
        calendarElement.statusClosure = {() in return true}
        config.otherElements.append(calendarElement)
        */
        
        // uncomment this section to add a new custom entry in "Terms and Conditions"
        //let customTerm = Term(type: .Custom, titleKey: "term-custom-title", contentKey: "term-custom-content")
        //config.terms.append(customTerm)
        
        // uncomment this section to fill what's displayed in "Terms and Conditions"
        var terms = [Term]()
        terms.append(Term(type: .Video, titleKey: "terms-video-title", contentKey: "terms-video-content"))
        terms.append(Term(type: .Text, titleKey: "terms-data-usage-title", contentKey: "terms-data-usage-content"))
        terms.append(Term(type: .Text, titleKey: "terms-help-title", contentKey: "terms-help-content"))
        terms.append(Term(type: .Text, titleKey: "terms-more-info-title", contentKey: "terms-more-info-content"))
        config.terms = terms
        
        // finally, initialize TrustBadgeManager with our configuration
        TrustBadgeManager.with(config)
        
        return true
    }
}

