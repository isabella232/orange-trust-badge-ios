/*
*
* OrangeTrustBadge
*
* File name:   PermissionCell.swift
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

class ElementCell: UITableViewCell {
    
    static let reuseIdentifier = "Element"
    var toggleClosure : (ElementCell)-> Void = {(cell) in }
    var openPreferencesClosure : ()-> Void = {() in }
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var disclosureArrow: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionPanel: UIView!
    @IBOutlet weak var toggle: UISwitch!
    
    @IBOutlet weak var actionButtonHiddingConstraint : NSLayoutConstraint!
    @IBOutlet weak var switchHiddingConstraint : NSLayoutConstraint!
    @IBOutlet weak var statusHiddingConstraint : NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHiddingConstraint : NSLayoutConstraint!
    
    @IBAction func openPreferences(){
        self.openPreferencesClosure()
    }
    
    @IBAction func toggleSwitch(){
        self.toggleClosure(self)
    }
    
    override func awakeFromNib() {
        self.statusLabel.isAccessibilityElement = false
        self.nameLabel.isAccessibilityElement = false
        self.accessibilityTraits = UIAccessibilityTraits.button
    }
}
