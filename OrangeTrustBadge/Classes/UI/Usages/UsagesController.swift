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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = TrustBadgeManager.sharedInstance.localizedString("usages-title")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        self.tableView.register(UINib(nibName: "ElementCell", bundle: Bundle(for: TrustBadgeConfig.self)), forCellReuseIdentifier: ElementCell.reuseIdentifier)
        tableView.estimatedRowHeight = 65       
        tableView.configure(header: header, with: TrustBadgeManager.sharedInstance.localizedString("usages-header-title"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_USAGE_ENTER), object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrustBadgeManager.sharedInstance.usageElements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = TrustBadgeManager.sharedInstance.usageElements[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ElementCell.reuseIdentifier, for: indexPath) as! ElementCell
        
        if element is Rating {
            cell.nameLabel.text = TrustBadgeManager.sharedInstance.localizedString("rating-title")
        } else {
            cell.nameLabel.text = TrustBadgeManager.sharedInstance.localizedString(element.nameKey)
        }
        
        let description = TrustBadgeManager.sharedInstance.localizedString(element.descriptionKey)
        var attributeddDescription : NSAttributedString?
        do {
            attributeddDescription = try NSAttributedString(data: description.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            cell.descriptionLabel.attributedText = attributeddDescription
        } catch {
            cell.descriptionLabel.text = description
        }
        
        cell.descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        let statusKey :String = {
            if element.statusClosure() {
                return "status-enabled"
            } else {
                return "status-disabled"
            }
        }()
        cell.statusLabel.text = TrustBadgeManager.sharedInstance.localizedString(statusKey)
        cell.statusLabel.textColor = element.statusClosure() ? TrustBadgeManager.sharedInstance.config?.highlightColor : UIColor.black
        cell.icon.image = element.statusClosure() ? TrustBadgeManager.sharedInstance.loadImage(element.statusEnabledIconName) : TrustBadgeManager.sharedInstance.loadImage(element.statusDisabledIconName)
        cell.actionButton.setTitle(TrustBadgeManager.sharedInstance.localizedString("update-permission"), for: UIControlState())
        
        cell.toggle.setOn(element.statusClosure(), animated: true)
        if element.isToggable{
            cell.toggle.isHidden = false
            cell.toggle.isAccessibilityElement = true
            cell.statusLabel.isHidden = true
            cell.switchHiddingConstraint.priority = 250
        } else {
            cell.toggle.isHidden = true
            cell.toggle.isAccessibilityElement = false
            cell.statusLabel.isHidden = false
            cell.switchHiddingConstraint.priority = 999
        }
        
        if element.showStatus{
            cell.statusHiddingConstraint.priority = 250
            cell.statusLabel.isHidden = false
        } else {
            cell.statusHiddingConstraint.priority = 750
            cell.statusLabel.isHidden = true
        }
        
        if element.isExpanded{
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                cell.disclosureArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                cell.descriptionLabel.isHidden = false
                cell.descriptionLabelHiddingConstraint.priority = 250
                cell.actionPanel.isHidden = !element.isConfigurable
                cell.actionButtonHiddingConstraint.priority = element.isConfigurable ? 250 : 999
            })
            
        } else{
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                cell.disclosureArrow.transform = CGAffineTransform(rotationAngle: CGFloat(-2 * Double.pi))
                cell.descriptionLabel.isHidden = true
                cell.descriptionLabelHiddingConstraint.priority = 999
                cell.actionPanel.isHidden = true
                cell.actionButtonHiddingConstraint.priority = 999
            })
        }
        
        cell.toggleClosure = { (cell : ElementCell) in
            element.toggleClosure(cell.toggle)
            NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_ELEMENT_TOGGLED), object: element)
        }
        
        cell.openPreferencesClosure = { () in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_GO_TO_SETTINGS), object: element)
        }
        
        let status = element.statusClosure() ? TrustBadgeManager.sharedInstance.localizedString("accessibility-enabled") :  TrustBadgeManager.sharedInstance.localizedString("accessibility-disabled")
        cell.accessibilityValue = "\(TrustBadgeManager.sharedInstance.localizedString(element.nameKey)) : \(status)"
        cell.accessibilityHint = TrustBadgeManager.sharedInstance.localizedString("accessibility-double-tap")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let element = TrustBadgeManager.sharedInstance.usageElements[(indexPath as NSIndexPath).row]
        if element.isExpanded {
            return UITableViewAutomaticDimension
        } else {
            return 65
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = TrustBadgeManager.sharedInstance.usageElements[(indexPath as NSIndexPath).row]
        element.isExpanded = !element.isExpanded
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_ELEMENT_TAPPED), object: element)
    }
}
