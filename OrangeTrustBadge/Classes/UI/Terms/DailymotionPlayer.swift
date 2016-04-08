/*
 *
 * OrangeTrustBadge
 *
 * File name:   DailymotionPlayer.swift
 * Created:     07/04/2016
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

public class DailymotionPlayer : UIWebView, UIWebViewDelegate {
    
    static let DMAPIVersion = "2.9.3"
    
    let webBaseURLString = "https://www.dailymotion.com"
    
    convenience init(video : NSString){
        self.init()
        self.load(video)
    }
    
    public func load(video : NSString){
        self.delegate = self
        
        // Remote white default background
        self.opaque = false
        self.backgroundColor = UIColor.clearColor()
        
        // Autoresize by default
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
        
        
        // Hack: prevent vertical bouncing
        for subview in self.subviews {
            if (subview.isKindOfClass(UIScrollView)) {
                (subview as! UIScrollView).bounces = false
                (subview as! UIScrollView).scrollEnabled = false
            }
        }
        
        let url = NSMutableString(format: "%@/embed/video/%@?api=location&objc_sdk_version=%@&endscreen-enable=false&sharing-enable=false", self.webBaseURLString, video, DailymotionPlayer.DMAPIVersion)
        let appName = NSBundle.mainBundle().bundleIdentifier;
        url.appendFormat("&app=%@", appName!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        self.loadRequest(NSURLRequest(URL: NSURL(string: url as String)!))
    }
    
    deinit{
        self.delegate = nil
        self.stopLoading()
    }
    
    public func pause(){
        self.stringByEvaluatingJavaScriptFromString("player.api(\"pause\", \"null\")")
    }
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let isInitialURL = request.URL?.path?.hasPrefix("/embed/video/"){
            return isInitialURL
        } else {
            return false
        }
    }
}