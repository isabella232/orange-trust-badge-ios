/*
*
* OrangeTrustBadgeDemo
*
* File name:   OrangeButton.swift
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


@IBDesignable
public class OrangeButton: UIButton {
    
    @IBInspectable var normalBorderColor = UIColor.clearColor()
    @IBInspectable var highlightedBorderColor = UIColor.clearColor()
    
    override public var highlighted: Bool {
        willSet(willBeHighlighted) {
            super.highlighted = willBeHighlighted
            self.borderColor = willBeHighlighted ? self.highlightedBorderColor : self.normalBorderColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        applyBrandCustomization()
        setupBorderColors()
        self.borderWidth = 3
        self.highlighted = false
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setupBorderColors() {
    }
    
    public override func prepareForInterfaceBuilder() {
        applyBrandCustomization()
    }
    
    func setTitleFont() {
        self.titleLabel?.font = UIFont.systemFontOfSize(20)
    }
    
    func applyBrandCustomization() {
    }
}


@IBDesignable
public class OrangeButtonStandard: OrangeButton {
    
    override func setupBorderColors() {
        self.normalBorderColor = UIColor.blackColor()
        self.highlightedBorderColor = UIColor.orangeColor()
    }
    
    override func applyBrandCustomization() {
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.clearColor()), forState: .Normal)
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.orangeColor()), forState: .Highlighted)
        self.setTitleFont()
    }
}

extension UIColor {
    class func orangeKitDarkOrangeColor() -> UIColor { return UIColor(red: 0.5804, green: 0.2235, blue: 0.0196, alpha: 1.0) }
    class func orangeKitGreenColor()      -> UIColor { return UIColor(red: 0.1529, green: 0.6314, blue: 0.1255, alpha: 1.0) }
    class func orangeKitDarkGreenColor()  -> UIColor { return UIColor(red: 0.0902, green: 0.3412, blue: 0.0784, alpha: 1.0) }
    class func orangeKitRedColor()        -> UIColor { return UIColor(red: 0.6824, green: 0.1255, blue: 0.0627, alpha: 1.0) }
    class func orangeKitDarkRedColor()    -> UIColor { return UIColor(red: 0.3686, green: 0.0784, blue: 0.0471, alpha: 1.0) }
}


extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor:self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
}


public extension UIImage {
    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextFillRect(context!, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
