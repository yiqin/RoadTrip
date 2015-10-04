//
//  ConfigDataManager.swift
//  Skyscraper
//
//  Created by Yi Qin on 5/11/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

/**
Configuration data from Parse.com
*/
class ConfigDataManager: NSObject {
    
    // MARK: - Set layout.
    var cellNodeHasPadding: Bool = true
    
    /// Object ID when the app doesn't have a NSUserDefaults value.
    var defaultLiveStreamObjectId: String = "tFBdWJJ79o"
    
    class var sharedInstance : ConfigDataManager {
        struct Static {
            static let instance = ConfigDataManager()
        }
        return Static.instance
    }
    
    func startToRetrieveConfig(completion: () -> Void) {
        PFConfig.getConfigInBackgroundWithBlock { (config: PFConfig?, error: NSError?) -> Void in
            
            let tempDefaultLiveStreamObjectId: AnyObject? = config?.objectForKey("defaultLiveStreamObjectId")
            if let temp = tempDefaultLiveStreamObjectId as? String {
                ConfigDataManager.sharedInstance.defaultLiveStreamObjectId = temp
            }
            
            completion()
        }
    }
}
