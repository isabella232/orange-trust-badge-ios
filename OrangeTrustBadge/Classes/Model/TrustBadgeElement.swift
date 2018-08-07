/*
*
* OrangeTrustBadge
*
* File name:   TrustBadgeElement.swift
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
import Foundation

/**
 *  This base class describes minimum informations needed to be displayed into OrangeTrustBadge component.
 
 Implementations are available through BasicPermission and CustomPermission class
 */
@objc open class TrustBadgeElement: NSObject {
    /// Flag telling if OrangeTrustBadge should display a switch to enable/disable the element
    @objc open var isToggable : Bool = false {
        didSet {
            if isToggable {
                showStatus = false
            }
        }
    }
    /// Closure allowing to update current element's status
    @objc open var toggleClosure : (UISwitch)-> Void = {(toggleSwitch) in }
    /// Closure giving element's status (enabled/disabled)
    @objc open var statusClosure : () -> Bool = {() in return false}
    /// Flag telling if OrangeTrustBadge should display the current status the element
    @objc open  var showStatus : Bool = true
    /// Flag telling if OrangeTrustBadge should display a link to iOS Preferences to enable/disable it.
    @objc open var isConfigurable : Bool = false
    /// Localized Key for element's name
    @objc open var nameKey : String = ""
    /// Localized Key for element's description
    @objc open var descriptionKey :String = ""
    /// Icon name for element's enabled state
    @objc open var statusEnabledIconName : String = ""
    /// Icon name for element's disabled state
    @objc open var statusDisabledIconName : String = ""
    /// Flag telling if the corresponding UI is expanded (display details)
    @objc open var isExpanded : Bool = false
}
