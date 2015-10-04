//
//  YQASCellNodeProtocol.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/29/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

protocol YQASCellNodeProtocol {
    /*
    var isImageReady:Bool
    var isLayoutReady:Bool
    var isDisplay:Bool
    */
    func calculateSizeThatFits(constrainedSize: CGSize)->CGSize
    func didLoad()
    func layout()
    func didExitHierarchy()
    
    /// I define this to display cell.
    func display()
    
}
