/*
*
* OrangeTrustBadge
*
* File name:   Helper.swift
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

class Helper {
    
    // MARK: Helper methods
    
    static func localizedString(key : String)-> String{
        let localizedStringFromAppBundle = NSLocalizedString(key, comment: "")
        if(localizedStringFromAppBundle == key){
            let localizedStringFromTrustBadgeBundle = NSLocalizedString(key, tableName: nil, bundle: NSBundle(forClass: TrustBadgeConfig.self), value: "", comment: "").stringByReplacingOccurrencesOfString("$$cssStylesheet$$", withString: TrustBadgeManager.sharedInstance.css).stringByReplacingOccurrencesOfString("$$applicationName$$", withString: TrustBadgeManager.sharedInstance.appName)
            
            if(localizedStringFromTrustBadgeBundle == key){
                return "To be localized key:\(key)"
            } else {
                return localizedStringFromTrustBadgeBundle
            }
        } else {
            return localizedStringFromAppBundle.stringByReplacingOccurrencesOfString("$$cssStylesheet$$", withString: TrustBadgeManager.sharedInstance.css).stringByReplacingOccurrencesOfString("$$applicationName$$", withString: TrustBadgeManager.sharedInstance.appName)
        }
    }
    
    static func loadImage(name : String)-> UIImage{
        if let imageFromAppBundle = UIImage(named: name){
            return imageFromAppBundle
        } else if let imageFromTrustBadgeBundle = UIImage(named: name, inBundle: NSBundle(forClass: TrustBadgeConfig.self), compatibleWithTraitCollection: nil){
            return imageFromTrustBadgeBundle
        } else {
            return UIImage(named: "permission-placeholder-icon", inBundle: NSBundle(forClass: TrustBadgeConfig.self), compatibleWithTraitCollection: nil)!
        }
    }
}