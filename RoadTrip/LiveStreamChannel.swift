//
//  LiveStreamChannel.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/30/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

// Anything you are archiving to NSData and back needs to implement the NSCoding protocol.
// http://stackoverflow.com/questions/26224808/converting-swift-array-to-nsdata-for-nsuserdefaults-standarduserdefaults-persist
class LiveStreamChannel: NSParseObject {
    
    var title:String
    
    override init(parseObject: PFObject) {
        
        if let tempTitle = parseObject["title"] as? String {
            title = tempTitle
        } else {
            title = ""
        }
        
        super.init(parseObject: parseObject)
    }
    
    
    
}
