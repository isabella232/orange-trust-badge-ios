/*
*
* OrangeTrustBadge
*
* File name:   TermsController.swift
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

class TermsController: UITableViewController {
    
    @IBOutlet weak var header : Header!
    var players = [String : DailymotionPlayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = Helper.localizedString("terms-title")
        self.header.title.text = Helper.localizedString("terms-header-title")
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName(TrustBadgeManager.TRUSTBADGE_TERMS_ENTER, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        players = [String : DailymotionPlayer]()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrustBadgeManager.sharedInstance.terms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let term = TrustBadgeManager.sharedInstance.terms[indexPath.row]
        if term.type == .Video{
            let cell = tableView.dequeueReusableCellWithIdentifier(TermVideoCell.reuseIdentifier, forIndexPath: indexPath) as! TermVideoCell
            cell.title.text = Helper.localizedString(term.titleKey)            
            
            let videoId = Helper.localizedString(term.contentKey)
            var player = players[videoId]
            if player == nil {
                player = DailymotionPlayer(video: videoId)
                players.updateValue(player!, forKey: videoId)
            }
            player!.pause()
            player!.frame = cell.videoView.frame
            cell.videoView.addSubview(player!)
            player!.translatesAutoresizingMaskIntoConstraints = false
            cell.videoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":player!]))
            cell.videoView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":player!]))
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(TermCell.reuseIdentifier, forIndexPath: indexPath) as! TermCell
            cell.title.text = Helper.localizedString(term.titleKey)
            let content = Helper.localizedString(term.contentKey)
            let font = UIFont.systemFontOfSize(15)
            let formattedContent = String(format: content + "<style>body{font-family: '%@'; font-size:%@px;}</style>", arguments: [font.fontName, font.pointSize.description])
            let attributedContent = try! NSAttributedString(data: formattedContent.dataUsingEncoding(NSUnicodeStringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            cell.content.attributedText = attributedContent
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
