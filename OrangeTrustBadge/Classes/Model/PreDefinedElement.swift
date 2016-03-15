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
public enum ElementType : String{
    /// Identity Element (firstname, lastname etc...)
    case Identity = "identity"
    /// Permission to access user's location
    case Location = "location"
    /// Permission to access user's Photo Library
    case PhotoLibrary = "photo-library"
    /// Permission to access user's Address Book
    case Contacts = "contacts"
    /// Permission to anonymously track user's activity within the app
    case DataUsage = "data-usage"
    /// Permission to access user's Camera
    case Camera = "camera"
    /// Permission to access user's Calendar
    case Calendar = "calendar"
    /// Permission to access user's Microphone
    case Microphone = "microphone"
    /// Permission to access user's phone number
    case Phone = "phone"
    /// Permission to access user's Health and Sensors data
    case BodySensors = "body-sensors"
    /// Permission to access user's profile on Twitter/Facebook
    case SocialSharing = "social-sharing"
    /// Permission to pay within the app
    case InAppPurchase = "inapp-purchase"
    /// Permission to store cookies for marketing purposes
    case Advertising = "advertising"
    
    public static let defaultMainElementTypes  : [ElementType] = [Identity, Location, PhotoLibrary, Contacts, DataUsage]
    
    public static let defaultOtherElementTypes : [ElementType] = []
    
    public static let defaultUsageElementTypes : [ElementType] = [SocialSharing, InAppPurchase, Advertising]
}

/// A PreDefinedElement is a pre-defined TrustBadgeElement, often backed by a system-permission (e.g. Location for instance)
public class PreDefinedElement: TrustBadgeElement {
    
    /// Type of a PreDefinedElement
    let type : ElementType
    
    /// Flag telling if the manager should autoConfigure the element
    public var shouldBeAutoConfigured : Bool = true
    
    /**
     Standard initializer
     
     - parameter type: desired ElementType
     - returns: initialized PreDefinedElement object
     */
    public init(type : ElementType) {
        self.type = type
        super.init()
        nameKey = "permission-\(self.type.rawValue)-name"
        descriptionKey = "permission-\(self.type.rawValue)-description"
        statusEnabledIconName = "permission-\(self.type.rawValue)-enabled-icon"
        statusDisabledIconName = "permission-\(self.type.rawValue)-disabled-icon"
    }
}
