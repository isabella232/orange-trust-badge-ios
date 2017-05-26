/*
*
* OrangeTrustBadge
*
* File name:   PermissionsController.swift
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

class PermissionsController: UITableViewController {
    
    
    @IBOutlet weak var header : Header!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = TrustBadgeManager.sharedInstance.localizedString("permission-title")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        self.header.title.text = TrustBadgeManager.sharedInstance.localizedString("permission-header-title")
        self.tableView.register(UINib(nibName: "ElementCell", bundle: Bundle(for: TrustBadgeConfig.self)), forCellReuseIdentifier: ElementCell.reuseIdentifier)
        tableView.estimatedRowHeight = 65

        NotificationCenter.default.addObserver(self, selector: #selector(PermissionsController.refresh), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_PERMISSION_ENTER), object: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if TrustBadgeManager.sharedInstance.otherElements.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0 :
            return TrustBadgeManager.sharedInstance.mainElements.count
        default :
            return TrustBadgeManager.sharedInstance.otherElements.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elementForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ElementCell.reuseIdentifier, for: indexPath) as! ElementCell
        
        cell.nameLabel.text = TrustBadgeManager.sharedInstance.localizedString(element.nameKey)
        let description = TrustBadgeManager.sharedInstance.localizedString(element.descriptionKey)
        let attributeddDescription = try! NSAttributedString(data: description.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        cell.descriptionLabel.attributedText = attributeddDescription
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
        
        cell.toggle.setOn(element.statusClosure(), animated: false)
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
        
        cell.toggleClosure = {(cell : ElementCell) in
            element.toggleClosure(cell.toggle)
            NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_ELEMENT_TOGGLED), object: element)
        }
        
        cell.openPreferencesClosure = { () in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_GO_TO_SETTINGS), object: element)
        }
        
        let status = element.statusClosure() ? TrustBadgeManager.sharedInstance.localizedString("accessibility-enabled") : TrustBadgeManager.sharedInstance.localizedString("accessibility-disabled")
        cell.accessibilityValue = "\(TrustBadgeManager.sharedInstance.localizedString(element.nameKey)) : \(status)"
        cell.accessibilityHint = TrustBadgeManager.sharedInstance.localizedString("accessibility-double-tap")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let element = elementForIndexPath(indexPath)
        if element.isExpanded {
            return UITableViewAutomaticDimension
        } else {
            return 65
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elementForIndexPath(indexPath)
        element.isExpanded = !element.isExpanded
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_ELEMENT_TAPPED), object: element)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0 :
            return TrustBadgeManager.sharedInstance.localizedString("permission-main-section-name")
        default :
            return TrustBadgeManager.sharedInstance.localizedString("permission-others-section-name")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.black
    }
    
    // MARK: - Other Methods
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func elementForIndexPath(_ indexPath : IndexPath) -> TrustBadgeElement{
        switch((indexPath as NSIndexPath).section){
        case 0 :
            return TrustBadgeManager.sharedInstance.mainElements[(indexPath as NSIndexPath).row]
        default :
            return TrustBadgeManager.sharedInstance.otherElements[(indexPath as NSIndexPath).row]
        }
    }
    
}
