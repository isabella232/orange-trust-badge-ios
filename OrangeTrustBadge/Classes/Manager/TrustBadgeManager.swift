/*
*
* OrangeTrustBadge
*
* File name:   TrustBadgeManager.swift
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
import EventKit
import CoreLocation
import Photos
import Contacts
import AVKit

/// TrustBadgeConfig aims to encapsulate all the configuration variables and custom handlers of TrustBadgeManager
public class TrustBadgeConfig : NSObject{
    
    /// Name of the app, (Default : Bundle Display Name of host app)
    public var appName : String?
    
    /// (Optional) Rating of your application (Default : 4+)
    public var rating = Rating(type: RatingType.Level4)
    
    /// (Optional) UIColor used to highlight element with a positive status (default black)
    public var highlightColor = UIColor.blackColor()
    
    /// (Optional) background UIColor of the header (default blue)
    public var headerColor = UIColor(red: 57/256, green: 176/256, blue: 168/256, alpha: 1)
    
    /// (Optional) Status bar style (default Application's default statusBarStyle)
    public var statusBarStyle = UIApplication.sharedApplication().statusBarStyle
    
    /** (Optional) Closure giving Tracking (Data Usage Permission) status (enabled/disabled) (Default : disabled)
     
     Example :
     
     ```
     let config = TrustBadgeConfig()
     config.isTrackingEnabled = {() in return NSUserDefaults.standardUserDefaults().boolForKey("TRACKING_KEY")}
     ```
     */
    public var isTrackingEnabled : (Void) -> Bool = {() in return false}
    
    /// (Optional) Closure giving Identity usage (Identity ElementType) status (enabled/disabled) (Default : disabled)
    public var isIdentityUsed : (Void) -> Bool = {() in return true}
    
    /// (Optional) Closure giving Social Sharing (Social Sharing ElementType) status (enabled/disabled) (Default : disabled)
    public var isSocialSharingUsed : (Void) -> Bool = {() in return false}
    
    /// (Optional) Closure giving InApp Purchase (InApp Purchase ElementType) status (enabled/disabled) (Default : disabled)
    public var isInappPurchaseUsed : (Void) -> Bool = {() in return false}
    
    /// (Optional) Closure giving Advertisement (Advertisement ElementType) status (enabled/disabled) (Default : disabled)
    public var isAdvertisementUsed : (Void) -> Bool = {() in return false}
    
    /** (Optional) Closure allowing to update the Tracking (Data Usage ElementType) status (enabled/disabled).
     
     Example :
     
     ```
     let config = TrustBadgeConfig()
     config.updateTracking = {(Bool status) in NSUserDefaults.standardUserDefaults().setBool(status, forKey: "TRACKING_KEY")}
     ```
     */
    public var updateTracking : (UISwitch)-> Void = {(toggle) in }
    
    /** (Optional) List of TrustBadgeElements that should be displayed in "Main Elements" section. If you append an TrustBadgeElement to the Array, it will add it at the end of it. If you want to ave full control of what should be displayed, please assign a new array to this property. This section must contains at least 1 element to let TrustBadgeManager initialize properly.
     
     Example :
     
     ```
     let myCustomElement = CustomElement(nameKey: "custom-permission-name-key", descriptionKey: "custom-permission-description-key", statusEnabledIconName: "permission-credit-card-enabled-icon", statusDisabledIconName: "permission-credit-card-disabled-icon")
     myCustomElement.isConfigurable = false
     myCustomElement.statusClosure = {() in return true}
     config.mainElements.append(myCustomElement)
     
     //or with pre-defined permissions such as Calendar :
     
     let calendarElement = PreDefinedElement(type: .Calendar)
     config.mainElements.append(calendarElement)
     ```
     */
    public lazy var mainElements  : [TrustBadgeElement] = self.initializeMainElements()
    
    /** (Optional) List of TrustBadgeElements that should be displayed in "Other Elements" section. If you append an TrustBadgeElement to the Array, it will add it at the end of it. If you want to ave full control of what should be displayed, please assign a new array to this property. If no elements are in the list, this section will not be displayed. (empty by default)
     
     Example :
     
     ```
     let myCustomElement = CustomElement(nameKey: "custom-permission-name-key", descriptionKey: "custom-permission-description-key", statusEnabledIconName: "permission-credit-card-enabled-icon", statusDisabledIconName: "permission-credit-card-disabled-icon")
     myCustomElement.isConfigurable = false
     myCustomElement.statusClosure = {() in return true}
     config.otherElements.append(myCustomElement)
     
     //or with pre-defined permissions such as Calendar :
     
     let calendarElement = PreDefinedElement(type: .Calendar)
     config.otherElements.append(calendarElement)
     ```
     */
    public lazy var otherElements : [TrustBadgeElement] = self.initializeOtherElements()
    
    /** (Optional) List of TrustBadgeElements that should be displayed in "Usage" section. If you append an TrustBadgeElement to the Array, it will add it at the end of it. If you want to ave full control of what should be displayed, please assign a new array to this property.
     
     Example :
     
     ```
     let myCustomElement = CustomElement(nameKey: "custom-permission-name-key", descriptionKey: "custom-permission-description-key", statusEnabledIconName: "permission-credit-card-enabled-icon", statusDisabledIconName: "permission-credit-card-disabled-icon")
     myCustomElement.isConfigurable = false
     myCustomElement.statusClosure = {() in return true}
     config.usageElements.append(myCustomElement)
     
     //or with pre-defined permissions such as Calendar :
     
     let calendarElement = PreDefinedElement(type: .Calendar)
     config.usageElements.append(calendarElement)
     ```
     */
    public lazy var usageElements : [TrustBadgeElement] = self.initializeUsageElements()
    
    /** (Optional) List of Terms and Conditions that should be displayed in "terms and conditions" section. (empty by default)
     
     Example :
     
     ```
     let customTerm = Term(type: .Text, titleKey: "terms-data-usage-title", contentKey: "terms-data-usage-content")
     config.terms = [customTerm]
     ```
     */
    public lazy var terms = [Term]()
    
    /**
     Convenience method to create the array of the default TrustBadgeElement that should be displayed in Main Elements section.
     
     - returns: an initialized array of TrustBadgeElement
     */
    public func initializeMainElements() -> [TrustBadgeElement] {
        var defaults = [TrustBadgeElement]()
        for type in ElementType.defaultMainElementTypes{
            defaults.append(PreDefinedElement(type : type))
        }
        return defaults
    }
    
    /**
     Convenience method to create the array of the default TrustBadgeElement that should be displayed in Other Elements section.
     
     - returns: an initialized array of TrustBadgeElement
     */
    public func initializeOtherElements() -> [TrustBadgeElement] {
        var defaults = [TrustBadgeElement]()
        for type in ElementType.defaultOtherElementTypes{
            defaults.append(PreDefinedElement(type : type))
        }
        return defaults
    }
    
    /**
     Convenience method to create the array of the default TrustBadgeElement that should be displayed in Usage Elements section.
     
     - returns: an initialized array of TrustBadgeElement
     */
    public func initializeUsageElements() -> [TrustBadgeElement] {
        var defaults = [TrustBadgeElement]()
        for type in ElementType.defaultUsageElementTypes{
            defaults.append(PreDefinedElement(type : type))
        }
        return defaults
    }
    
    /**
     Convenience method to find elements of a given type in order to configure it directly. 
     This method will search over all elements in every collections the Manager is responsible for
     
     - parameter type: type of the Element
     
     - returns: array of PreDefinedElements matching a given type
     */
    public func elementForType(type : ElementType) -> [PreDefinedElement] {
        var searchedElements = [PreDefinedElement]()
        for mainElement in self.mainElements {
            if mainElement is PreDefinedElement {
                let preDefinedElement = mainElement as! PreDefinedElement
                if preDefinedElement.type == type {
                    searchedElements.append(preDefinedElement)
                }
            }
        }
        for otherElement in self.otherElements {
            if otherElement is PreDefinedElement {
                let preDefinedElement = otherElement as! PreDefinedElement
                if preDefinedElement.type == type {
                    searchedElements.append(preDefinedElement)
                }
            }
        }
        for usageElement in self.usageElements {
            if usageElement is PreDefinedElement {
                let preDefinedElement = usageElement as! PreDefinedElement
                if preDefinedElement.type == type {
                    searchedElements.append(preDefinedElement)
                }
            }
        }
        return searchedElements
    }
    
}

/// TrustBadgeManager Class is the heart of OrangeTrustBadge
public class TrustBadgeManager: NSObject {
    
    /// Event triggered when entering in TrustBadge component
    public static let TRUSTBADGE_ENTER = "TRUSTBADGE_ENTER"
    
    /// Event triggered when entering in Permissions Page
    public static let TRUSTBADGE_PERMISSION_ENTER = "TRUSTBADGE_PERMISSION_ENTER"
    
    /// Event triggered when entering in Usage Page
    public static let TRUSTBADGE_USAGE_ENTER = "TRUSTBADGE_USAGE_ENTER"
    
    /// Event triggered when entering in Terms Page
    public static let TRUSTBADGE_TERMS_ENTER = "TRUSTBADGE_TERMS_ENTER"
    
    /// Event triggered when leaving TrustBadge component
    public static let TRUSTBADGE_LEAVE = "TRUSTBADGE_LEAVE"
    
    /// Event triggered when tapping a TrustBadge element to open/close associated explanations
    public static let TRUSTBADGE_ELEMENT_TAPPED = "TRUSTBADGE_ELEMENT_TAPPED"
    
    /// Event triggered when toggling a TrustBadge element (if toggable)
    public static let TRUSTBADGE_ELEMENT_TOGGLED = "TRUSTBADGE_ELEMENT_TOGGLED"
    
    /// Event triggered when going into iOS settings
    public static let TRUSTBADGE_GO_TO_SETTINGS = "TRUSTBADGE_GO_TO_SETTINGS"
    
    /// Access to the manager's singleton
    public static let sharedInstance = TrustBadgeManager()
    
    /// Access to the terms collection
    var terms = [Term]()
    
    var config : TrustBadgeConfig?
    
    var mainElements  = [TrustBadgeElement]()
    var otherElements = [TrustBadgeElement]()
    var usageElements = [TrustBadgeElement]()
    
    var css = ""
    var appName = ""
    /**
     Starting point to integrate TrustBadge SDK into your app.
     Simply provide a Configuration object in order to initialize the SDK : it will contains parameters and hooks to customize standard SDK behaviours.
     
     Example :
     
     ```
     let config = TrustBadgeConfig()
     TrustBadgeManager.with(config)
     ```
     
     - parameter configuration: An TrustBadgeConfig containing TrustBadge configuration
     */
    public static func with(configuration : TrustBadgeConfig) {
        sharedInstance.config = configuration
        sharedInstance.initialize()
    }
    
    func initialize(){
        
        //initialize main Elements
        if let mainElements = self.config?.mainElements{
            self.mainElements.appendContentsOf(mainElements)
            self.configurePredefinedElements(self.mainElements)
        }
        
        assert(self.mainElements.count > 0, "You must have at least 1 element in Main Elements section to initialize this manager")
        
        //initialize other Elements
        if let otherElements = self.config?.otherElements{
            self.otherElements.appendContentsOf(otherElements)
            self.configurePredefinedElements(self.otherElements)
        }
        
        //initialize usage and rating Elements
        
        if let rating = config?.rating{
            self.usageElements.append(rating)
        }
        
        if let usageElements = self.config?.usageElements{
            self.usageElements.appendContentsOf(usageElements)
            self.configurePredefinedElements(self.usageElements)
        }
        
        if let terms = self.config?.terms{
            self.terms.appendContentsOf(terms)
        }
        
        //load css file
        if let cssFromAppBundle = NSBundle.mainBundle().pathForResource("style", ofType: "css"){
            self.css = try! String(contentsOfFile: cssFromAppBundle)
        } else {
            let cssFromTrustBadgeBundle = NSBundle(forClass: TrustBadgeConfig.self).pathForResource("style", ofType: "css")!
            self.css = try! String(contentsOfFile: cssFromTrustBadgeBundle)
        }
        
        //load custom appName
        if let customName = config?.appName{
            self.appName = customName
        } else {
            if let bundleDisplayName = NSBundle.mainBundle().objectForInfoDictionaryKey("kCFBundleDisplayName"){
                self.appName = bundleDisplayName as! String
            } else if let bundleName = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String){
                self.appName = bundleName as! String
            } else {
                print("You should setup a custom application name in TrustBadgeConfig")
            }
        }
    }
    
    func configurePredefinedElements(elements : [TrustBadgeElement]) {
        for element in elements {
            if element is PreDefinedElement {
                let preDefinedElement = element as! PreDefinedElement
                if preDefinedElement.shouldBeAutoConfigured{
                    switch(preDefinedElement.type){
                    case .Calendar :
                        preDefinedElement.statusClosure = {() in return EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) == EKAuthorizationStatus.Authorized}
                        preDefinedElement.isConfigurable = true
                    case .Location :
                        preDefinedElement.statusClosure = {() in return ![CLAuthorizationStatus.Denied,CLAuthorizationStatus.NotDetermined,CLAuthorizationStatus.Restricted].contains(CLLocationManager.authorizationStatus()) }
                        preDefinedElement.isConfigurable = true
                    case .PhotoLibrary :
                        preDefinedElement.statusClosure = {() in return ![PHAuthorizationStatus.Denied,PHAuthorizationStatus.NotDetermined,PHAuthorizationStatus.Restricted].contains(PHPhotoLibrary.authorizationStatus()) }
                        preDefinedElement.isConfigurable = true
                    case .Contacts :
                        if #available(iOS 9.0, *) {
                            preDefinedElement.statusClosure = {() in return ![CNAuthorizationStatus.Denied,CNAuthorizationStatus.NotDetermined,CNAuthorizationStatus.Restricted].contains(CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts))}
                        } else {
                            preDefinedElement.statusClosure = {() in return ![ABAuthorizationStatus.Denied,ABAuthorizationStatus.NotDetermined,ABAuthorizationStatus.Restricted].contains(ABAddressBookGetAuthorizationStatus())}
                        }
                        preDefinedElement.isConfigurable = true
                    case .Microphone :
                        preDefinedElement.statusClosure = {() in return ![AVAudioSessionRecordPermission.Denied,AVAudioSessionRecordPermission.Undetermined].contains(AVAudioSession.sharedInstance().recordPermission())}
                        preDefinedElement.isConfigurable = true
                    case .Camera :
                        preDefinedElement.statusClosure = {() in return ![AVAuthorizationStatus.Denied,AVAuthorizationStatus.NotDetermined,AVAuthorizationStatus.Restricted].contains(AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo))}
                        preDefinedElement.isConfigurable = true
                    case .DataUsage :
                        preDefinedElement.isToggable = true
                        preDefinedElement.statusClosure = (TrustBadgeManager.sharedInstance.config?.isTrackingEnabled)!
                        preDefinedElement.toggleClosure = (TrustBadgeManager.sharedInstance.config?.updateTracking)!
                    case .Identity :
                        preDefinedElement.statusClosure = (TrustBadgeManager.sharedInstance.config?.isIdentityUsed)!
                    case .SocialSharing :
                        preDefinedElement.statusClosure = (TrustBadgeManager.sharedInstance.config?.isSocialSharingUsed)!
                    case .InAppPurchase :
                        preDefinedElement.statusClosure = (TrustBadgeManager.sharedInstance.config?.isInappPurchaseUsed)!
                    case .Advertising :
                        preDefinedElement.statusClosure = (TrustBadgeManager.sharedInstance.config?.isAdvertisementUsed)!
                    default: break
                    }
                }
            }
        }
    }
}