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
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = Helper.localizedString("terms-title")
        self.header.title.text = Helper.localizedString("terms-header-title")
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_TERMS_ENTER), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        players = [String : DailymotionPlayer]()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrustBadgeManager.sharedInstance.terms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let term = TrustBadgeManager.sharedInstance.terms[(indexPath as NSIndexPath).row]
        if term.type == .video{
            let cell = tableView.dequeueReusableCell(withIdentifier: TermVideoCell.reuseIdentifier, for: indexPath) as! TermVideoCell
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
            cell.videoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":player!]))
            cell.videoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":player!]))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TermCell.reuseIdentifier, for: indexPath) as! TermCell
            cell.title.text = Helper.localizedString(term.titleKey)
            let content = Helper.localizedString(term.contentKey)
            let font = UIFont.systemFont(ofSize: 15)
            let formattedContent = String(format: content + "<style>body{font-family: '%@'; font-size:%@px;}</style>", arguments: [font.fontName, font.pointSize.description])
            let attributedContent = try! NSAttributedString(data: formattedContent.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
            cell.content.attributedText = attributedContent
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
