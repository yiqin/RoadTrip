//
//  Factories.swift
//  AppStore
//
//  Created by yiqin on 4/15/15.
//  Copyright (c) 2015 yiqin. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    class func attributedStringForTitleText(text: String) -> NSAttributedString {
        
        let font = UIFont(name: "Lato-Semibold", size: 15) ?? UIFont.systemFontOfSize(15)
        
        let titleAttributes = [NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        /*
        let titleAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(20),
                    NSForegroundColorAttributeName: UIColor.blackColor(),
                             NSShadowAttributeName: NSShadow.titleTextShadow(),
                     NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
        */
        return NSAttributedString(string: text, attributes: titleAttributes)
    }

    class func attributedStringForDescriptionText(text: String) -> NSAttributedString {
        
        let font = UIFont(name: "Lato-Regular", size: 13) ?? UIFont.systemFontOfSize(13)
        
        let descriptionAttributes = [NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        /*
        let descriptionAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(13),
                                   NSShadowAttributeName: NSShadow.descriptionTextShadow(),
                          NSForegroundColorAttributeName: UIColor.blackColor(),
                          NSBackgroundColorAttributeName: UIColor.clearColor(),
                           NSParagraphStyleAttributeName: NSParagraphStyle.justifiedParagraphStyle()]
        */
        return NSAttributedString(string: text, attributes: descriptionAttributes)
    }
    
}

extension NSParagraphStyle {
    class func justifiedParagraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Justified
        return paragraphStyle.copy() as! NSParagraphStyle
    }
}

extension NSShadow {
    class func titleTextShadow() -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }

    class func descriptionTextShadow() -> NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }
}
