/*
*
* OrangeTrustBadge
*
* File name:   UsagesController.swift
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

class UsagesController: UITableViewController {
    
    @IBOutlet weak var header : Header!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = Helper.localizedString("usages-title")
        self.header.title.text = Helper.localizedString("usages-header-title")
        self.tableView.registerNib(UINib(nibName: "ElementCell", bundle: NSBundle(forClass: TrustBadgeConfig.self)), forCellReuseIdentifier: ElementCell.reuseIdentifier)
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName(TrustBadgeManager.TRUSTBADGE_USAGE_ENTER, object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrustBadgeManager.sharedInstance.usageElements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let element = TrustBadgeManager.sharedInstance.usageElements[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(ElementCell.reuseIdentifier, forIndexPath: indexPath) as! ElementCell
        
        if element is Rating {
            cell.nameLabel.text = Helper.localizedString("rating-title")
        } else {
            cell.nameLabel.text = Helper.localizedString(element.nameKey)
        }
        
        let description = Helper.localizedString(element.descriptionKey)
        var attributeddDescription : NSAttributedString?
        do {
            attributeddDescription = try NSAttributedString(data: description.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            cell.descriptionLabel.attributedText = attributeddDescription
        } catch {
            cell.descriptionLabel.text = description
        }
        
        cell.descriptionLabel.font = UIFont.systemFontOfSize(14)
        let statusKey :String = {
            if element.statusClosure() {
                return "status-enabled"
            } else {
                return "status-disabled"
            }
        }()
        cell.statusLabel.text = Helper.localizedString(statusKey)
        cell.statusLabel.textColor = element.statusClosure() ? TrustBadgeManager.sharedInstance.config?.highlightColor : UIColor.blackColor()
        cell.icon.image = element.statusClosure() ? Helper.loadImage(element.statusEnabledIconName) : Helper.loadImage(element.statusDisabledIconName)
        cell.actionButton.setTitle(Helper.localizedString("update-permission"), forState: UIControlState.Normal)
        
        cell.toggle.setOn(element.statusClosure(), animated: true)
        if element.isToggable{
            cell.toggle.hidden = false
            cell.toggle.isAccessibilityElement = true
            cell.statusLabel.hidden = true
            cell.switchHiddingConstraint.priority = 250
        } else {
            cell.toggle.hidden = true
            cell.toggle.isAccessibilityElement = false
            cell.statusLabel.hidden = false
            cell.switchHiddingConstraint.priority = 999
        }
        
        if element.showStatus{
            cell.statusHiddingConstraint.priority = 250
            cell.statusLabel.hidden = false
        } else {
            cell.statusHiddingConstraint.priority = 750
            cell.statusLabel.hidden = true
        }
        
        if element.isExpanded{
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                cell.disclosureArrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                cell.descriptionLabel.hidden = false
                cell.descriptionLabelHiddingConstraint.priority = 250
                cell.actionPanel.hidden = !element.isConfigurable
                cell.actionButtonHiddingConstraint.priority = element.isConfigurable ? 250 : 999
            })
            
        } else{
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                cell.disclosureArrow.transform = CGAffineTransformMakeRotation(CGFloat(-2 * M_PI))
                cell.descriptionLabel.hidden = true
                cell.descriptionLabelHiddingConstraint.priority = 999
                cell.actionPanel.hidden = true
                cell.actionButtonHiddingConstraint.priority = 999
            })
        }
        
        cell.toggleClosure = { (cell : ElementCell) in
            element.toggleClosure(cell.toggle)
            NSNotificationCenter.defaultCenter().postNotificationName(TrustBadgeManager.TRUSTBADGE_ELEMENT_TOGGLED, object: element)
        }
        
        cell.openPreferencesClosure = { () in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            NSNotificationCenter.defaultCenter().postNotificationName(TrustBadgeManager.TRUSTBADGE_GO_TO_SETTINGS, object: element)
        }
        
        let status = element.statusClosure() ? Helper.localizedString("accessibility-enabled") :  Helper.localizedString("accessibility-disabled")
        cell.accessibilityValue = "\(Helper.localizedString(element.nameKey)) : \(status)"
        cell.accessibilityHint = Helper.localizedString("accessibility-double-tap")
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let element = TrustBadgeManager.sharedInstance.usageElements[indexPath.row]
        if element.isExpanded {
            return UITableViewAutomaticDimension
        } else {
            return 65
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let element = TrustBadgeManager.sharedInstance.usageElements[indexPath.row]
        element.isExpanded = !element.isExpanded
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.endUpdates()
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        NSNotificationCenter.defaultCenter().postNotificationName(TrustBadgeManager.TRUSTBADGE_ELEMENT_TAPPED, object: element)
    }
}
