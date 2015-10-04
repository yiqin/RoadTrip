//
//  LiveStreamCellNode.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/29/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class LiveStreamFeedCellNode: ASCellNode, YQASCellNodeProtocol {
    
    var liveSteamFeed:LiveStreamFeed
    
    
    var statusNode:ASTextNode = ASTextNode()
    var locationNameNode:ASTextNode = ASTextNode()
    
    var keywordsNode:ASTextNode = ASTextNode()
    
    
    var imageNodes:[ASNetworkImageNode] = []
    
    
    var isImageReady:Bool = false
    var isLayoutReady: Bool = false
    var isDisplay:Bool = false
    
    
    
    init(liveStreamFeed:LiveStreamFeed){
        self.liveSteamFeed = liveStreamFeed
        
        
        super.init()
        
        imageNodes = []
        for imageParseFile in liveSteamFeed.imageParseFiles {
            
            let tempImageNode = ASNetworkImageNode(webImage: ())
            tempImageNode.URL = NSURL(string: imageParseFile.url!)
            // tempImageNode.cornerRadius = 5
            tempImageNode.clipsToBounds = true
            tempImageNode.placeholderEnabled = true
            tempImageNode.placeholderColor = ASDisplayNodeDefaultPlaceholderColor()
            /*
            // These don't work.
            tempImageNode.placeholderEnabled = true
            tempImageNode.placeholderColor = lightGrey
            tempImageNode.placeholderFadeDuration = 10.0
            */
            
            addSubnode(tempImageNode)
            imageNodes += [tempImageNode]
        }
        
        
        let statusFont = UIFont(name: "Lato-Regular", size: 15) ?? UIFont.systemFontOfSize(15)
        let statusAttributes = [NSFontAttributeName: statusFont, NSForegroundColorAttributeName: darkGrey]
        statusNode.attributedString = NSAttributedString(string: liveSteamFeed.status, attributes: statusAttributes)
        addSubnode(statusNode)
        
        
        // MARK - Not perfect.
        let locationNameFont = UIFont(name: "Lato-Regular", size: 12) ?? UIFont.systemFontOfSize(12)
        let locationNameAttributes = [NSFontAttributeName: locationNameFont, NSForegroundColorAttributeName: lightGrey]
        locationNameNode.attributedString = NSAttributedString(string: liveSteamFeed.createdAt.timeAgoSinceNow()+" — at "+liveSteamFeed.locationName, attributes: locationNameAttributes)
        addSubnode(locationNameNode)
        
        
        
        let keywordsFont = UIFont(name: "Lato-Regular", size: 12) ?? UIFont.systemFontOfSize(12)
        let keywordsAttributes = [NSFontAttributeName: keywordsFont, NSForegroundColorAttributeName: lightRed]
        
        var keywordsString:String = ""
        for keyword in liveStreamFeed.keywords {
            if keywordsString.isEmpty {
                keywordsString = keyword
            } else {
                keywordsString = keywordsString + ", " + keyword
            }
        }
        
        keywordsNode.attributedString = NSAttributedString(string: keywordsString, attributes: keywordsAttributes)
        addSubnode(keywordsNode)
        
        backgroundColor = UIColor.whiteColor()
        
    }
    
    
    func calculateSizeThatFits(constrainedSize: CGSize)->CGSize {
        
        statusNode.measure(CGSizeMake(constrainedSize.width-2*xPadding, constrainedSize.height))
        locationNameNode.measure(CGSizeMake(constrainedSize.width-2*xPadding, constrainedSize.height))
        
        var tempSize:CGSize = CGSize()
        var tempHeight = statusNode.calculatedSize.height + locationNameNode.calculatedSize.height  + 0.5*yPadding + CGFloat(self.liveSteamFeed.imageParseFiles.count)*(screenWidth*0.7+yPadding)+yPadding
        
        keywordsNode.measure(CGSizeMake(constrainedSize.width-2*xPadding, constrainedSize.height))
        if liveSteamFeed.keywords.count > 0 {
            tempHeight = tempHeight + keywordsNode.calculatedSize.height + 0.5*yPadding
        }
        
        tempSize = CGSizeMake(constrainedSize.width, tempHeight)
        return tempSize
    }
    
    
    func didLoad(){
        
    }
    
    
    func layout(){
        
        var tempY:CGFloat = 0
        
        tempY = tempY+yPadding
        statusNode.frame = CGRectMake(xPadding, tempY, calculatedSize.width-2*xPadding, statusNode.calculatedSize.height)
        
        tempY = tempY + statusNode.calculatedSize.height + 0.5*yPadding
        locationNameNode.frame = CGRectMake(xPadding, tempY, calculatedSize.width-2*xPadding, locationNameNode.calculatedSize.height)
        
        if liveSteamFeed.keywords.count > 0 {
            tempY = tempY + locationNameNode.calculatedSize.height + yPadding*0.5
            keywordsNode.frame = CGRectMake(xPadding, tempY, calculatedSize.width-2*xPadding, keywordsNode.calculatedSize.height)
        }
        
        tempY = tempY + keywordsNode.calculatedSize.height + yPadding*1.5
        for imageNode in imageNodes {
            // Tune the size
            imageNode.frame = CGRectMake(-xPadding*0.5, tempY, calculatedSize.width+xPadding, screenWidth*0.7)
            tempY = tempY+screenWidth*0.7+yPadding
        }
        
    }
    
    
    func didExitHierarchy(){
        isDisplay = false
        
    }
    
    
    func display(){
        
    }
    
    
}
