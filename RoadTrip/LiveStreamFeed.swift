//
//  LiveStreamFeed.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/29/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class LiveStreamFeed: NSParseObject {
    
    var status:String
    var locationName:String
    
    var imageParseFiles:[PFFile]
    
    var keywords:[String]
    
    override init(parseObject: PFObject) {
        
        if let tempStatus = parseObject["status"] as? String {
            status = tempStatus
        } else {
            status = ""
        }
        
        if let tempLocationName = parseObject["locationName"] as? String {
            locationName = tempLocationName
        } else {
            locationName = ""
        }
        
        imageParseFiles = []
        if let tempImageObjects = parseObject["images"] as? [AnyObject] {
            for tempImageObject in tempImageObjects {
                if let tempImageParseFile = tempImageObject["image"] as? PFFile {
                    imageParseFiles += [tempImageParseFile]
                }
            }
        } else {
            
        }
        
        keywords = []
        if let tempKeywords = parseObject["keywords"] as? [AnyObject] {
            for tempKeyword in tempKeywords {
                keywords += [tempKeyword as! String]
            }
        } else {
            
        }
        
        super.init(parseObject: parseObject)
        
    }
    
}
