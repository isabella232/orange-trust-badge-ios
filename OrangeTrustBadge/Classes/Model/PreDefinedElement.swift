/*
*
* OrangeTrustBadge
*
* File name:   PreDefinedElement.swift
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

import Foundation

/// Enum describing the type of a PreDefinedElement
@objc public enum ElementType : Int{
    /// Identity Element (firstname, lastname etc...)
    case identity
    /// Permission to access user's location
    case location
    /// Permission to access user's Photo Library
    case photoLibrary
    /// Permission to access user's Address Book
    case contacts
    /// Permission to anonymously track user's activity within the app
    case dataUsage
    /// Permission to access user's Camera
    case camera
    /// Permission to access user's Calendar
    case calendar
    /// Permission to access user's Microphone
    case microphone
    /// Permission to access user's phone number
    case phone
    /// Permission to access user's Health and Sensors data
    case bodySensors
    /// Permission to access user's profile on Twitter/Facebook
    case socialSharing
    /// Permission to pay within the app
    case inAppPurchase
    /// Permission to store cookies for marketing purposes
    case advertising
    
    func name() -> String {
        switch self {
            case .identity: return "identity"
            case .location: return "location"
            case .photoLibrary: return "photo-library"
            case .contacts: return "contacts"
            case .dataUsage : return "data-usage"
            case .camera : return "camera"
            case .calendar : return "calendar"
            case .microphone : return "microphone"
            case .phone : return "phone"
            case .bodySensors : return "body-sensors"
            case .socialSharing : return "social-sharing"
            case .inAppPurchase : return "inapp-purchase"
            case .advertising : return "advertising"
        }
    }
    
    public static let defaultMainElementTypes  : [ElementType] = [identity, location, photoLibrary, contacts, dataUsage]
    
    public static let defaultOtherElementTypes : [ElementType] = []
    
    public static let defaultUsageElementTypes : [ElementType] = [socialSharing, inAppPurchase, advertising]
}

/// A PreDefinedElement is a pre-defined TrustBadgeElement, often backed by a system-permission (e.g. Location for instance)
open class PreDefinedElement: TrustBadgeElement {
    
    /// Type of a PreDefinedElement
    let type : ElementType
    
    /// Flag telling if the manager should autoConfigure the element
    open var shouldBeAutoConfigured : Bool = true
    
    /**
     Standard initializer
     
     - parameter type: desired ElementType
     - returns: initialized PreDefinedElement object
     */
    public init(type : ElementType) {
        self.type = type
        super.init()
        nameKey = "permission-\(self.type.name())-name"
        descriptionKey = "permission-\(self.type.name())-description"
        statusEnabledIconName = "permission-\(self.type.name())-enabled-icon"
        statusDisabledIconName = "permission-\(self.type.name())-disabled-icon"
    }
}
