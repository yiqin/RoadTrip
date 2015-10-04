//
//  DetailBodyWebView.swift
//  Reading
//
//  Created by Yi Qin on 3/31/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class DetailBodyWebView: UIWebView {
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = UIColor.whiteColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
