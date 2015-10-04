//
//  SoftwareProjectTableViewCellSetting.swift
//  RoadTrip
//
//  Created by Yi Qin on 4/23/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class UISettingManager: NSObject {
    
    class func getHeaderLabelFont()->UIFont {
        let font = UIFont(name: "OpenSans-Bold", size: 13.0) ?? UIFont.systemFontOfSize(13)
        return font
    }
    
    class func getTitleLabelFont()->UIFont {
        let font = UIFont(name: "Lato-Regular", size: 20) ?? UIFont.systemFontOfSize(20)
        return font
    }
    
    class func getSubtitleLabelFont()->UIFont {
        let font = UIFont(name: "Lato-Regular", size: 13.0) ?? UIFont.systemFontOfSize(13)
        return font
    }
    
    class func getDescriptionLabelFont()->UIFont {
        let font = UIFont(name: "Lato-Regular", size: 15) ?? UIFont.systemFontOfSize(15)
        return font
    }
    
    
    class func getXPadding1()->CGFloat {
        return 30
    }
    
    class func getXPadding2()->CGFloat {
        return 30
    }
    
    class func getYPadding1()->CGFloat {
        return 15
    }
    
    class func getFooterHeight()->CGFloat {
        return 70
    }
    
}
