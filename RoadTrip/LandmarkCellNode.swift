//
//  LandmarkCellNode.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/26/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class LandmarkCellNode: ASCellNode, ASNetworkImageNodeDelegate, YQASCellNodeProtocol {
    
    
    var landmark:Landmark
    
    
    var titleNode:ASTextNode = ASTextNode()
    var taglineNode:ASTextNode = ASTextNode()
    
    
    
    var blurredImageNode = ASNetworkImageNode(webImage: ()) //ASImageNode() // blurred
    // with cache
    var regularImageNode = ASNetworkImageNode(webImage: ())
    
    
    var isImageReady:Bool = false
    var isLayoutReady: Bool = false
    var isDisplay:Bool = false
    
    
    
    // MARK: - We have opened too many threads.
    // http://stackoverflow.com/questions/26020832/ios-app-crashes-xcode-says-lost-connection-to-xs-iphone-when-debugging
    
    init(landmark:Landmark){
        
        self.landmark = landmark
        
        super.init()
        print("ASCellNode init")
        
                
        // More setting are needed here.
        blurredImageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        blurredImageNode.alpha = 1
        addSubnode(blurredImageNode)
        
        /*
        if (self.landmark.image == nil) {

        }
        else {
            // regularImageNode.image = self.landmark.image
        }
        */
        

        if landmark.imageParseFiles.count > 0{
            let imageParseFile = landmark.imageParseFiles[0]
            
            // No cache here... So....
            regularImageNode.URL = NSURL(string: imageParseFile.url!)
        }

        
        // Process two image from the networking.....
        let imageParseFile = landmark.lowQualityImage
        blurredImageNode.URL = NSURL(string: imageParseFile.url!)
        
        
        /*
        blurredImageNode.imageModificationBlock = { input in
            
            println("image modification block .... \(landmark.title)")
            
            if input == nil {
                return input
            }
            
            
            if NSThread.isMainThread() {
                
                println("main thread.....")
                
            }
            else {
                println("is not in main thread.")
            }
            
            
            if (self.landmark.blurredImage == nil) {
                
                let scaledDownImage = self.scaledDown(input)
                
                let blurredImage = scaledDownImage.applyBlurWithRadius(1, tintColor: UIColor(white: 0.2, alpha: 0.3), saturationDeltaFactor: 1.0, maskImage: nil)
                // self.landmark.blurredImage = blurredImage
                
                self.isImageReady = true
                
                // Only blurred one time...
                println("blurred")
                
                return blurredImage
            }
            else {
                return self.landmark.blurredImage
            }

            
            // return input
            
            /*
            let blurredImage = input.applyBlurWithRadius(30, tintColor: UIColor(white: 0.2, alpha: 0.3), saturationDeltaFactor: 1.8, maskImage: nil)
            self.landmark.blurredImage = blurredImage
            
            self.isImageReady = true
            
            // Only blurred one time...
            println("blurred")
            
            return blurredImage
            */
        }
        */
        
        
        // Only show one time....
        blurredImageNode.setNeedsDisplayWithCompletion { (canceled:Bool) -> Void in
            print("mmmmmm")
            

        }
        
        
        regularImageNode.setNeedsDisplayWithCompletion { (canceled:Bool) -> Void in
            if self.isDisplay {
                self.display()
            }
        }
        
        
        
        
        titleNode.attributedString = NSAttributedString.attributedStringForTitleText(landmark.title+", "+landmark.state)
        titleNode.alpha = 0.2
        addSubnode(titleNode)
        
        
        taglineNode.attributedString = NSAttributedString.attributedStringForDescriptionText(landmark.tagline)
        taglineNode.alpha = 0.2
        addSubnode(taglineNode)
        
        
        // regularImageNode.alpha = 1
        regularImageNode.placeholderEnabled = true
        regularImageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        regularImageNode.delegate = self
        addSubnode(regularImageNode)
        
        
        clipsToBounds = true
        backgroundColor = UIColor.whiteColor()
        // MARK - this is not good.
        // cornerRadius = 5
    }
    
    
    func calculateSizeThatFits(constrainedSize: CGSize)->CGSize {
        print("calculate size that fits")
        
        // Measure the size.
        var taglineSize:CGSize = CGSizeZero
        taglineSize = taglineNode.measure(CGSizeMake(constrainedSize.width-2*xPadding, constrainedSize.height))
        
        var titleSize:CGSize = CGSizeZero
        titleSize = titleNode.measure(CGSizeMake(constrainedSize.width-2*xPadding, constrainedSize.height))
                
        
        var tempSize:CGSize = CGSize()
        let tempHeight = screenWidth*0.45+titleSize.height+taglineSize.height+3*yPadding
        
        
        // MARK: - this changes the size of the image...
        tempSize = CGSizeMake(constrainedSize.width, tempHeight)
        
        return tempSize
        
    }
    
    
    func didLoad(){
        print("ASCellNode view load...")
        
    }
    
    
    func layout(){
        isLayoutReady = true
        
        print("ASCellNode layout...")
        
        
        blurredImageNode.frame = CGRectMake(0, calculatedSize.height-screenWidth*0.45, calculatedSize.width, screenWidth*0.45)
        
        regularImageNode.frame = CGRectMake(0, 0, calculatedSize.width, screenWidth*0.45)
        
        
        
        titleNode.frame = CGRectMake(xPadding+40, CGRectGetMaxY(regularImageNode.frame)+yPadding, calculatedSize.width-2*xPadding, titleNode.calculatedSize.height)
        
        taglineNode.frame = CGRectMake(xPadding, CGRectGetMaxY(titleNode.frame)+yPadding*0.5, calculatedSize.width-2*xPadding, taglineNode.calculatedSize.height)
        
    }
    
    
    func didExitHierarchy(){
        isDisplay = false
        
    }
    
    
    func display(){
        
        if isImageReady && isLayoutReady {
            
            // POP animation.
            let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            anim.fromValue = 0
            anim.toValue = 1
            // regularImageNode.pop_addAnimation(anim, forKey: "fade")
            // imageNode.pop_addAnimation(anim, forKey: "fade")
            
            
            
            // UIView animation
            self.titleNode.frame = CGRectMake(xPadding*1.5, self.titleNode.frame.origin.y, self.titleNode.frame.width, self.titleNode.frame.height)
            
            self.titleNode.alpha = 0.2
            self.taglineNode.alpha = 0.2
            
            
            UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                
                self.titleNode.frame = CGRectMake(xPadding, self.titleNode.frame.origin.y, self.titleNode.frame.width, self.titleNode.frame.height)
                
                self.titleNode.alpha = 1.0
                self.taglineNode.alpha = 1.0
                
                }) { (finish:Bool) -> Void in
                    
            }
        }// end check isImageReady && isLayoutReady
        
    }
    
    
    func imageNode(imageNode: ASNetworkImageNode!, didLoadImage image: UIImage!) {
        print("laod image ....\(landmark.title)")
        
        self.isImageReady = true
        
        landmark.image = image
        
        // regularImageNode.image = image
        // blurredImageNode.image = image
        
        
        
        // For testing.
        /*
        let scaledImage = scaledDown(image)
        let blurredImage = scaledImage.applyBlurWithRadius(3, tintColor: UIColor(white: 0.2, alpha: 0.3), saturationDeltaFactor: 1.5, maskImage: nil)
        testPostToParse(blurredImage)
        */
    }
    
    
    // MARK: not sure how and where to use this function.
    func takeSnapshotOfView(view:UIView!) -> UIImage {
        UIGraphicsBeginImageContext(CGSizeMake(screenWidth-2*xPadding, 230))
        view.drawViewHierarchyInRect(CGRectMake(0, 0, screenWidth-2*xPadding, 230), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    func scaledDown(image:UIImage) -> UIImage {
        
        // The target size of the scaled image
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.05, 0.05))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        
        // testPostToParse(scaledImage)
        
        return scaledImage
    }
    
    
    // MARK : - Send a test post to Parse, If possible, move this part to the Playground....
    func testPostToParse(image:UIImage){
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let imageFile = PFFile(name:"lowQualityImage.jpg", data:imageData!)
        landmark.parseObject["LandmarkImage"] = imageFile
        
        landmark.parseObject.saveInBackgroundWithBlock { (succeed:Bool, error:NSError?) -> Void in
            
        }
        
    }
    
}
