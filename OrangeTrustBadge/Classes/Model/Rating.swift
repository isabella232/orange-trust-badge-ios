/*
*
* OrangeTrustBadge
*
* File name:   Rating.swift
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

/**
 Describes different rating types depending on available content within the app
 
 - Level4:      This application is made for all (4 years old and older)
 - Level9:      This application may contain inappropriate content which may not be suitable for children under the age of 9.
 - Level12:     This application may contain inappropriate content which may not be suitable for children under the age of 12.
 - Level17:     This application may contain inappropriate content which may not be suitable for children under the age of 17.
 - CustomLevel: Custom rating if needed
 */
@objc public enum RatingType : Int{
    /// This application is made for all (4 years old and older)
    case level4
    /// This application may contain inappropriate content which may not be suitable for children under the age of 9.
    case level9
    /// This application may contain inappropriate content which may not be suitable for children under the age of 12.
    case level12
    /// This application may contain inappropriate content which may not be suitable for children under the age of 17.
    case level17
    /// Custom rating if needed
    case customLevel
    
    func name() -> String {
        switch self {
            case .level4: return "level-4"
            case .level9: return "level-9"
            case .level12: return "level-12"
            case .level17: return "level-17"
            case .customLevel : return "level-17"
        }
    }
}

/// This class aims to encapsulate all informations about a rating (name, description and logo)
open class Rating: TrustBadgeElement {
    
    /// Rating's type
    var type : RatingType
    
    /**
     Constructor based on Rating Type
     
     - parameter type: desired type of rating
     
     - returns: a properly initialized rating object
     */
    public init(type : RatingType) {
        self.type = type
        super.init()
        self.nameKey = "rating-\(type.name())-name"
        self.descriptionKey = "rating-\(type.name())-description"
        self.statusEnabledIconName = "rating-\(type.name())-icon"
        self.statusDisabledIconName = "rating-\(type.name())-icon"
        self.showStatus = false
    }
}
