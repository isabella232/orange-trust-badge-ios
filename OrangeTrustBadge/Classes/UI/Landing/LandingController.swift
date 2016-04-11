/*
*
* OrangeTrustBadge
*
* File name:   LandingController.swift
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

class LandingController: UITableViewController {
    
    var mainGestureRecognizer : UIGestureRecognizer?
    var usageGestureRecognizer : UIGestureRecognizer?
    @IBOutlet weak var header : Header!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            self.clearsSelectionOnViewWillAppear = false
        }
        self.navigationItem.title = Helper.localizedString("landing-title")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.estimatedRowHeight = 70
        NSNotificationCenter.defaultCenter().postNotificationName(TrustBadgeManager.TRUSTBADGE_ENTER, object: nil)
        
        mainGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LandingController.goToMainElements(_:)))
        usageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LandingController.goToUsageElements(_:)))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        header.title.text = Helper.localizedString("landing-header-title")
        self.manageLogoVisibility()
        self.tableView.reloadData()
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.manageLogoVisibility()
    }
    
    /**
     Hide the logo on MasterView when sizeClass != .Compact (e.g on iPad and Iphone6 Plus for instance)
     */
    func manageLogoVisibility(){
        if let header = self.header{
            if (self.splitViewController?.traitCollection.horizontalSizeClass != .Compact) {
                header.logo.hidden = true
                header.hiddingConstraint.priority = 999
            } else {
                header.logo.hidden = false
                header.hiddingConstraint.priority = 250
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.row) {
        case 0 :
            if (self.splitViewController?.traitCollection.horizontalSizeClass == .Compact) {
                let cell = tableView.dequeueReusableCellWithIdentifier(ElementMenuCell.reuseIdentifier, forIndexPath: indexPath) as! ElementMenuCell
                cell.title.text = Helper.localizedString("landing-permission-title")
                cell.content.text = Helper.localizedString("landing-permission-content")
                cell.representedObject = TrustBadgeManager.sharedInstance.mainElements
                cell.overview.reloadData()
                cell.overview.removeGestureRecognizer(mainGestureRecognizer!)
                cell.overview.removeGestureRecognizer(usageGestureRecognizer!)
                cell.overview.addGestureRecognizer(mainGestureRecognizer!)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell", forIndexPath: indexPath)
                cell.textLabel?.text = Helper.localizedString("landing-permission-title")
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(17)
                return cell
            }
        case 1 :
            if (self.splitViewController?.traitCollection.horizontalSizeClass == .Compact) {
                let cell = tableView.dequeueReusableCellWithIdentifier(ElementMenuCell.reuseIdentifier, forIndexPath: indexPath) as! ElementMenuCell
                cell.title.text = Helper.localizedString("landing-usages-title")
                cell.content.text = Helper.localizedString("landing-usages-content")
                cell.representedObject = TrustBadgeManager.sharedInstance.usageElements
                cell.overview.reloadData()
                cell.overview.removeGestureRecognizer(mainGestureRecognizer!)
                cell.overview.removeGestureRecognizer(usageGestureRecognizer!)
                cell.overview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LandingController.goToUsageElements(_:))))
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell", forIndexPath: indexPath)
                cell.textLabel?.text = Helper.localizedString("landing-usages-title")
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(17)
                return cell
            }
        case 2 :
            if (self.splitViewController?.traitCollection.horizontalSizeClass == .Compact) {
                let cell = tableView.dequeueReusableCellWithIdentifier(TermsMenuCell.reuseIdentifier, forIndexPath: indexPath) as! TermsMenuCell
                cell.title.text = Helper.localizedString("landing-terms-title")
                cell.content.text = Helper.localizedString("landing-terms-content")
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell", forIndexPath: indexPath)
                cell.textLabel?.text = Helper.localizedString("landing-terms-title")
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(17)
                return cell
            }
            
        default :
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.splitViewController?.traitCollection.horizontalSizeClass == .Compact) {
            return UITableViewAutomaticDimension
        } else {
            return 55
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row){
        case 0 :
            self.performSegueWithIdentifier("Permissions", sender: self)
        case 1 :
            self.performSegueWithIdentifier("Usages", sender: self)
        case 2 :
            self.performSegueWithIdentifier("Terms", sender: self)
        default :
            break
        }
    }
    
    // MARK
    
    @IBAction func dismissModal(){
        self.splitViewController?.preferredDisplayMode = .PrimaryHidden
        self.splitViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(TrustBadgeManager.TRUSTBADGE_LEAVE, object: nil)
        })
    }
    
    @objc func goToMainElements(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            self.performSegueWithIdentifier("Permissions", sender: self)
        }
    }
    
    @objc func goToUsageElements(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            self.performSegueWithIdentifier("Usages", sender: self)
        }
    }
    
}
