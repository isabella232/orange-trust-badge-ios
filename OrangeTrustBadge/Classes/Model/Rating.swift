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
public enum RatingType : String{
    /// This application is made for all (4 years old and older)
    case Level4  = "level-4"
    /// This application may contain inappropriate content which may not be suitable for children under the age of 9.
    case Level9  = "level-9"
    /// This application may contain inappropriate content which may not be suitable for children under the age of 12.
    case Level12 = "level-12"
    /// This application may contain inappropriate content which may not be suitable for children under the age of 17.
    case Level17 = "level-17"
    /// Custom rating if needed
    case CustomLevel  = "custom"
}

/// This class aims to encapsulate all informations about a rating (name, description and logo)
public class Rating: TrustBadgeElement {
    
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
        self.nameKey = "rating-\(type.rawValue)-name"
        self.descriptionKey = "rating-\(type.rawValue)-description"
        self.statusEnabledIconName = "rating-\(type.rawValue)-icon"
        self.statusDisabledIconName = "rating-\(type.rawValue)-icon"
        self.showStatus = false
    }
}
