/*
*
* OrangeTrustBadge
*
* File name:   ElementMenuCell.swift
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

class ElementMenuCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    
    static let reuseIdentifier = "ElementMenu"
    
    var representedObject : [TrustBadgeElement]?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var overview: UICollectionView!
    
    override func awakeFromNib() {
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.shouldGroupAccessibilityChildren = false
    }
    
    // MARK: - Collection View data source
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let elements = representedObject else {
            return UICollectionViewCell()
        }
        
        let element = elements[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ElementOverViewCell.reuseIdentifier, for: indexPath) as! ElementOverViewCell
        
        let statusKey :String = {
            if element.statusClosure() {
                return "status-enabled"
            } else {
                return "status-disabled"
            }
        }()
        
        if element is Rating{
            cell.status.text = TrustBadgeManager.sharedInstance.localizedString(element.nameKey)
            cell.status.textColor = UIColor.black
            cell.accessibilityValue = "\(TrustBadgeManager.sharedInstance.localizedString("rating-title")) : \(TrustBadgeManager.sharedInstance.localizedString(element.nameKey))"
        } else {
            cell.status.text = TrustBadgeManager.sharedInstance.localizedString(statusKey)
            cell.status.textColor = element.statusClosure() ? TrustBadgeManager.sharedInstance.config?.highlightColor : UIColor.black
            let status = element.statusClosure() ? TrustBadgeManager.sharedInstance.localizedString("accessibility-enabled") :  TrustBadgeManager.sharedInstance.localizedString("accessibility-disabled")
            cell.accessibilityValue = "\(TrustBadgeManager.sharedInstance.localizedString(element.nameKey)) : \(status)"
        }
        
        cell.icon.image = element.statusClosure() ? TrustBadgeManager.sharedInstance.loadImage(element.statusEnabledIconName) : TrustBadgeManager.sharedInstance.loadImage(element.statusDisabledIconName)
        cell.accessibilityHint = TrustBadgeManager.sharedInstance.localizedString("accessibility-double-tap")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let elements = representedObject else{
            return 0
        }
        return elements.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
