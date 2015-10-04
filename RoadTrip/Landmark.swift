//
//  Landmark.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/26/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class Landmark: NSParseObject {
    
    var title:String
    var state:String
    
    var tagline:String
    
    var imageParseFiles:[PFFile]
    
    var image:UIImage!
    var blurredImage:UIImage!
    
    
    var lowQualityImage:PFFile
    
    
    override init(parseObject: PFObject) {
        
        if let tempTitle = parseObject["title"] as? String {
            title = tempTitle
        } else {
            title = ""
        }
        
        if let tempState = parseObject["state"] as? String {
            state = tempState
        } else {
            state = ""
        }
        
        if let tempTagline = parseObject["tagline"] as? String {
            tagline = tempTagline
        } else {
            tagline = ""
        }
        
        imageParseFiles = []
        if let tempImageObjects = parseObject["images"] as? [AnyObject] {
            print("yes")
            
            print(tempImageObjects)
            
            for tempImageObject in tempImageObjects {
                if let tempImageParseFile = tempImageObject["image"] as? PFFile {
                    imageParseFiles += [tempImageParseFile]
                }
            }
            
        } else {
            print("no")
        }
        
        if let tempLowQualityImage = parseObject["LandmarkImage"] as? PFFile {
            lowQualityImage = tempLowQualityImage
        } else {
            lowQualityImage = PFFile()
        }
        
        
        super.init(parseObject: parseObject)
        
        
    }
    
    
    
}
