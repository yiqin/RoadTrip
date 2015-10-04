//
//  LiveStreamDataManager.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/29/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

/// Too many methods are in this data manager. I need to think about how to refactor this method. Keep the file in less than 50 lines.
class LiveStreamDataManager: NSObject {
    
    var isUploading:Bool = false
    
    var images:[UIImage] = []
    var status:String = ""
    var locationName:String = ""
    
    var channels:[LiveStreamChannel] = []
    
    // var currentChannel:LiveStreamChannel!
    
    
    class var sharedInstance : LiveStreamDataManager {
        struct Static {
            static let instance = LiveStreamDataManager()
        }
        return Static.instance
    }
    
    
    func addImage(image:UIImage){
        images += [image]
    }
    
    /// clear images, status, location Name
    func clearPostNewData(){
        images = []
        status = ""
        locationName = ""
    }
    
    /// Post the live stream feed to Parse
    func postToParse(completionClosure: (success :Bool) ->()){
        
        isUploading = true
        
        let liveStreamFeed = PFObject(className: "LiveStreamFeed")
        liveStreamFeed["locationName"] = locationName
        liveStreamFeed["status"] = status
        
        if let currentChannelObjectId = NSUserDefaultsDataManager.sharedInstance.fetchCurrentLiveStreamObjectId() {
            let channel = PFObject(className: "LiveStreamChannel")
            channel.objectId = currentChannelObjectId
            liveStreamFeed["channel"] = channel
        }
        
        liveStreamFeed.saveInBackgroundWithBlock { (succeed:Bool, error:NSError?) -> Void in
            
            if succeed {
                var i = self.images.count
                for image in self.images {
                    
                    LiveStreamDataManager.postImageToParse(liveStreamFeed, image: image, completionClosure: { (postImageSuccess) -> () in
                        if postImageSuccess {
                            i--
                            if i == 0 {
                                // Closure saveInBackgroundWithBlock
                                completionClosure(success: true)
                                self.isUploading = false
                                self.clearPostNewData()
                            }
                        }
                    })// end postImageToParse
                }
            }
            
        }// end save in background with block
        
    }
    
    
    
    class func loadChannels(completionClosure: (success :Bool) ->()){
        
        let query = PFQuery(className: "LiveStreamChannel")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error:NSError?) -> Void in
            
            if let tempObjects = objects as [AnyObject]? {
                for object in tempObjects {
                    let liveStreamChannel = LiveStreamChannel(parseObject: object as! PFObject)
                    LiveStreamDataManager.sharedInstance.channels += [liveStreamChannel]
                }
            }
            
            completionClosure(success: true)
        }
    }
    
    
    
    class func createNewChannelToParse(title:String, completionClosure: (success :Bool) ->()){
        
        let channel = PFObject(className: "LiveStreamChannel")
        channel["title"] = title
        channel.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                let liveStreamChannel = LiveStreamChannel(parseObject: channel)
                LiveStreamDataManager.sharedInstance.channels += [liveStreamChannel]
                NSUserDefaultsDataManager.sharedInstance.updateCurrentLiveStreamObjectId(channel.objectId!)
                
                completionClosure(success: true)
            }
        }
    }
    
    
    /// Load Live Stream feed data in the same Channel.
    class func loadDataFromParse(pageIndex:Int, completionClosure: (success :Bool, hasMore:Bool, objects:[AnyObject]?) ->()) {
        
        if let currentChannelObjectId = NSUserDefaultsDataManager.sharedInstance.fetchCurrentLiveStreamObjectId() {
            
            let query = PFQuery(className: "LiveStreamFeed")
            
            let channel = PFObject(className: "LiveStreamChannel")
            channel.objectId = currentChannelObjectId
            query.whereKey("channel", equalTo: channel)
            
            
            query.orderByDescending("createdAt")
            query.includeKey("images")
            
            // query.limit = trendingObjectsPerPage
            // query.skip = trendingObjectsPerPage*pageIndex
            // query.orderByDescending("updatedAt")
            // query.addDescendingOrder("createdAt")
            
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error:NSError?) -> Void in
                /*
                // remove repeat object
                var tempSet:NSMutableSet = []
                var results:[AnyObject] = []
                for object in objects as! [PFObject] {
                let trackId = object["trackId"] as! String
                if !tempSet.containsObject(trackId) {
                tempSet.addObject(trackId)
                results += [object]
                }
                }
                */
                
                // For future use. Please ignore it now.
                /*
                var tempFeeds:[App] = []
                for object in objects as! [PFObject] {
                let feed = Product(parseObject: object)
                tempFeeds += [feed]
                }
                */
                
                /*
                var tempHasMore:Bool = false
                if objects?.count < self.trendingObjectsPerPage {
                tempHasMore = false
                }
                else {
                tempHasMore = true
                }
                */
                
                completionClosure(success: true, hasMore: false, objects: objects)
            }
        }
        else {
            completionClosure(success: true, hasMore: false, objects: nil)
        }
    }
    
    
    
    
    /// MARK: - Resize the image, and then compress. The resizing part should be in the Cloud Code on Parse
    class func postImageToParse(liveStreamLivePFObject:PFObject, image:UIImage, completionClosure: (success :Bool) ->()){
        
        // resize the image. then compress.
        
        let imageScaled = image.scaledDown()
        
        // ##### Using the original image......
        // let imageData = UIImageJPEGRepresentation(image.fixOrientation(), 0.7)
        let imageData = UIImageJPEGRepresentation(imageScaled.fixOrientation(), 0.7)
        
        
        let imageFile = PFFile(name:"image.jpg", data:imageData!)
        
        var userPhoto = PFObject(className:"LiveStreamFeedImage")
        userPhoto["image"] = imageFile
        userPhoto["imageFileSize"] = NSByteCountFormatter.stringFromByteCount(Int64(imageData!.length), countStyle: NSByteCountFormatterCountStyle.Binary)
        userPhoto.saveInBackgroundWithBlock { (succeed:Bool, error:NSError?) -> Void in
            
            // We also need to send AlchemyAPI call to tag the image.
            let returnPFFile = userPhoto["image"] as! PFFile
            
            let urlString:String = returnPFFile.url!
            
            let manager = AFHTTPRequestOperationManager()
            let parameters = ["apikey":"ce2db198c2ab8af0f92e59eb1018ce95b01a798e", "outputMode":"json", "url":urlString, "forceShowAll": 0]
            
            manager.GET("http://access.alchemyapi.com/calls/url/URLGetRankedImageKeywords", parameters: parameters, success: { (requestOperation:AFHTTPRequestOperation!, result:AnyObject!) -> Void in
                
                
                print("Alchemy API success \(result)")
                
                // MARK - Link the image to the live stream feed
                // After save the image successfully, we link the image to the liveStream
                
                if let dict = result as? [String: AnyObject] {
                    
                    var keywords : [String] = []
                    
                    let imageKeywords = dict["imageKeywords"] as! [AnyObject]
                    for imageKeyword in imageKeywords {
                        if let tempImageKeyword = imageKeyword as? [String: AnyObject] {
                            let keyword:String = tempImageKeyword["text"] as! String
                            keywords += [keyword]
                        }
                    }
                    
                    let imageInformationDictionary = ["__type":"Pointer", "className":"LiveStreamFeedImage", "objectId":userPhoto.objectId!]
                    liveStreamLivePFObject["keywords"] = keywords
                    liveStreamLivePFObject.addUniqueObjectsFromArray([imageInformationDictionary], forKey: "images")
                    liveStreamLivePFObject.saveInBackgroundWithBlock { (succeed:Bool, error:NSError?) -> Void in
                        completionClosure(success: succeed)
                    }
                    
                }
                

                }, failure: { (requestOperation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    
                    print("Alchemy API failure \(error)")
                    
            })
            
        }
    }
    

}


