//
//  MainCollectionViewFlowLayout.swift
//  Playground
//
//  Created by Yi Qin on 5/10/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class MainCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        if ConfigDataManager.sharedInstance.cellNodeHasPadding {
            sectionInset = UIEdgeInsets(top: yPadding, left: 0, bottom: yPadding, right: 0)
            minimumLineSpacing = yPadding
        } else {
            sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            minimumLineSpacing = 0
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
