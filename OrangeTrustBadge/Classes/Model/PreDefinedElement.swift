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
@objc public enum ElementType : Int {
    
    //MARK: Device permissions
    /// Permission to access user's location
    case location
    /// Permission to access user's Address Book
    case contacts
    /// Permission to access user's Photo Library 
    case photoLibrary
    /// Permission to access user's Media Library
    case media
    /// Permission to access user's Calendar
    case calendar
    /// Permission to access user's Camera
    case camera
    /// Permission to access user's REminders
    case reminders
    /// Permission to share datas via Bluetooh
    case bluetoothSharing
    /// Permission to access user's Microphone
    case microphone
    /// Permission to access user's Music activity and Media Library
    case speechRecognition
    /// Permission to access user's Health data
    case health
    /// Permission to access user's Homekit data
    case homekit
    /// Permission to access user's Motion activity & Fitness data
    case motionFitness

    //MARK: Application Data
    /// Permission to receive local and remote notifications
    case notifications
    /// Identity Element (firstname, lastname etc...)
    case identity
    /// Permission to access user's account informations
    case accountInformations
    /// Permission to anonymously track user's activity within the app
    case dataUsage
    /// Permission to store cookies for marketing purposes
    case advertising
    /// Permission to ollects information about your preferences and usage history
    case history

    func name() -> String {
        switch self {
        case .location: return "location"
        case .contacts: return "contacts"
        case .photoLibrary: return "photo-library"
        case .media : return "media"
        case .calendar : return "calendar"
        case .camera : return "camera"
        case .reminders : return "reminders"
        case .bluetoothSharing : return "bluetooth-sharing"
        case .microphone : return "microphone"
        case .speechRecognition : return "speech-recognition"
        case .health: return "health"
        case .homekit: return "homekit"
        case .motionFitness : return "motion-activity-fitness"
        case .accountInformations : return "account-informations"
        case .advertising : return "advertising"
        case .identity: return "identity"
        case .dataUsage : return "data-usage"
        case .notifications: return "notifications"
        case .history: return "history"
        }
    }
    
    private var regularDevicePermissions: [ElementType] {
        return [.location, .contacts, .photoLibrary, .media, .calendar,
                .camera, .reminders, .bluetoothSharing, .microphone,
                .speechRecognition, .health, .homekit, .motionFitness]
    }
    /// true if self is a device permission
    public var isDevicePermission: Bool {
        return regularDevicePermissions.contains(self)
    }
}

/// A PreDefinedElement is a pre-defined TrustBadgeElement, often backed by a system-permission (e.g. Location for instance)
@objc open class PreDefinedElement: TrustBadgeElement {
    
    /// Type of a PreDefinedElement
    let type : ElementType
    
    /// Flag telling if the manager should autoConfigure the element
    @objc open var shouldBeAutoConfigured : Bool = true
    
    /**
     Standard initializer
     
     - parameter type: desired ElementType
     - returns: initialized PreDefinedElement object
     */
    @objc public init(type : ElementType) {
        self.type = type
        super.init()
        nameKey = "permission-\(self.type.name())-name"
        descriptionKey = "permission-\(self.type.name())-description"
        statusEnabledIconName = "permission-\(self.type.name())-enabled-icon"
        statusDisabledIconName = "permission-\(self.type.name())-disabled-icon"
    }
}
