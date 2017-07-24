/*
*
* OrangeTrustBadge
*
* File name:   Header.swift
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

class Header: UIView {
    
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var logo : UIImageView!
    @IBOutlet weak var hiddingConstraint : NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.backgroundColor = TrustBadgeManager.sharedInstance.config?.headerColor
        if let logoImage = TrustBadgeManager.sharedInstance.config?.headerLogo {
            logo.image = logoImage
        }
    }
}

extension UITableView {

    func configure(header: Header, with title: String, and titleColor: UIColor? = nil) {
        header.title.text = title
        header.title.textColor = titleColor
        // get a frame with the right height and make it the frame of the header
        self.layoutIfNeeded()
        header.title.preferredMaxLayoutWidth = header.title.frame.width // needed only for iOS 8
        var headerFrame = header.frame
        headerFrame.size.height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        header.frame = headerFrame
    }
}
