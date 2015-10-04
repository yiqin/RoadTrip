//
//  ScaleDownImage.swift
//  RoadTrip
//
//  Created by Yi Qin on 6/9/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import Foundation

extension UIImage {
    
    // MARK:
    func scaledDown() -> UIImage {
        
        let originWidth = self.size.width
        let ratio = 320/originWidth // size will be 640 width
        
        // The target size of the scaled image
        let size = CGSizeApplyAffineTransform(self.size, CGAffineTransformMakeScale(ratio, ratio))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        self.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return scaledImage
    }
    
    
    
    
}