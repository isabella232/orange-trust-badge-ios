/*
*
* OrangeTrustBadge
*
* File name:   Term.swift
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

/// Enum describing the type of a Term
public enum TermType : String{
    /// A block displaying textual terms of use
    case Text
    /// A block displaying a video in terms of use
    case Video = "video"
}

/// A Term is a block displayed in "Terms" section
public class Term: NSObject {
    
    /// Type of a Term
    public var type : TermType
    /// Localized Key for Term's title
    public var titleKey : String
    /// Localized Key for Term's content (could include HTML content)
    public var contentKey :String
    
    /**
     Initializer
     
     - parameter type:        desired TermType
     - parameter titleKey:    desired localized Key for Term's title
     - parameter contentKey:  desired localized Key for Term's content
     
     - returns: initialized Term object
     */
    public init(type : TermType, titleKey : String, contentKey : String) {
        self.type = type
        self.titleKey = titleKey
        self.contentKey = contentKey
    }
}
