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
public class TrustBadgeElement: NSObject {
    /// Flag telling if OrangeTrustBadge should display a switch to enable/disable the element
    public var isToggable : Bool = false
    /// Closure allowing to update current element's status
    public var toggleClosure : (UISwitch)-> Void = {(toggleSwitch) in }
    /// Closure giving element's status (enabled/disabled)
    public var statusClosure : (Void) -> Bool = {() in return false}
    /// Flag telling if OrangeTrustBadge should display the current status the element
    public  var showStatus : Bool = true
    /// Flag telling if OrangeTrustBadge should display a link to iOS Preferences to enable/disable it.
    public var isConfigurable : Bool = false
    /// Localized Key for element's name
    public var nameKey : String = ""
    /// Localized Key for element's description
    public var descriptionKey :String = ""
    /// Icon name for element's enabled state
    public var statusEnabledIconName : String = ""
    /// Icon name for element's disabled state
    public var statusDisabledIconName : String = ""
    /// Flag telling if the corresponding UI is expanded (display details)
    public var isExpanded : Bool = false
}
