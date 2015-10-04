//
//  NSUserDefaultsDataManager.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/30/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

/**
NSUserDefaults data from Parse.com
*/
class NSUserDefaultsDataManager: NSObject {
    
    var currentLiveStream:LiveStreamChannel!
    
    var currentLiveStreamObjectId:String!
    var currentLiveStreamTitle:String! // If we have several strings about Channel to store ....
    
    class var sharedInstance : NSUserDefaultsDataManager {
        struct Static {
            static let instance = NSUserDefaultsDataManager()
        }
        return Static.instance
    }
    
    
    // http://stackoverflow.com/questions/26224808/converting-swift-array-to-nsdata-for-nsuserdefaults-standarduserdefaults-persist
    func updateCurrentLiveStream(liveStream:LiveStreamChannel){
        currentLiveStream = liveStream
        let data = NSKeyedArchiver.archivedDataWithRootObject(liveStream)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentLiveStream")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func fetchCurrentLiveStream() -> LiveStreamChannel? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("currentLiveStream") as? NSData {
            let tempObject: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            currentLiveStream = tempObject as! LiveStreamChannel
            return currentLiveStream
        }
        else {
            return nil
        }
    }
    
    
    func updateCurrentLiveStreamObjectId(objectId:String){
        currentLiveStreamObjectId = objectId
        let data = NSKeyedArchiver.archivedDataWithRootObject(objectId)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentLiveStreamObjectId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func fetchCurrentLiveStreamObjectId() -> String? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("currentLiveStreamObjectId") as? NSData {
            let tempObject: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            currentLiveStreamObjectId = tempObject as! String
            return currentLiveStreamObjectId
        }
        else {
            //MARK: - 
            return ConfigDataManager.sharedInstance.defaultLiveStreamObjectId
        }
    }
    
}
