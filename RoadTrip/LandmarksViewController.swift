//
//  DemoViewController.swift
//  Playground
//
//  Created by Yi Qin on 5/10/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class LandmarksViewController: UIViewController, YQViewControllerProtocol, ASCollectionViewDataSource, ASCollectionViewDelegate {
    
    var collectionView:ASCollectionView
    
    var landmarks:[Landmark] = []
    
    let refreshController = UIRefreshControl()

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        collectionView = ASCollectionView(frame: CGRectZero, collectionViewLayout: MainCollectionViewFlowLayout(), asyncDataFetching: true)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        
        collectionView.backgroundColor = UIColor(red: 235.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0) // UIColor.whiteColor()        
        
        collectionView.asyncDataSource = self
        collectionView.asyncDelegate = self
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        createRefreshControl()
        
        view.addSubview(collectionView)
        
        loadDataFromParse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("LandmarksViewController - did receive memory warning.")
    }
    
    
    func refreshControlAction(){
        loadDataFromParse()
    }
    
    func loadDataFromParse(){
        LandmarksDataManager.loadDataFromParse(0, completionClosure: { (success:Bool, hasMore:Bool, objects:[AnyObject]?) -> () in
            
            self.landmarks = []
            
            if let tempObjects = objects as [AnyObject]? {
                for object in tempObjects {
                    let landmark = Landmark(parseObject: object as! PFObject)
                    self.landmarks += [landmark]
                }
            }
            
            // Let's double the size of landmarks.
            if let tempObjects = objects as [AnyObject]? {
                for object in tempObjects {
                    let landmark = Landmark(parseObject: object as! PFObject)
                    self.landmarks += [landmark]
                }
            }
            
            self.collectionView.reloadData()
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "endRefreshControl", userInfo: nil, repeats: false)
        })
    }
    
    func endRefreshControl(){
        self.refreshController.endRefreshing()
    }
    
    func createRefreshControl(){
        refreshController.tintColor = lightBlack
        refreshController.addTarget(self, action: "refreshControlAction", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshController)
    }
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = self.view.bounds
    }
    
    func customizeView(){
        title = LandmarksViewController.name()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    
    func collectionView(collectionView: ASCollectionView!, nodeForItemAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let node = LandmarkCellNode(landmark: landmarks[indexPath.row])
        return node
    }
    
    func collectionView(collectionView: ASCollectionView!, willDisplayNodeForItemAtIndexPath indexPath: NSIndexPath!) {
        let node = collectionView.nodeForItemAtIndexPath(indexPath) as! LandmarkCellNode
        node.isDisplay = true
        node.display()
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        print("select \(indexPath.row)")
        
        // When the user click this...
        
        let tempWeb = DetailViewController(nibName: nil, bundle: nil)
        // let navigationViewController = UINavigationController(rootViewController: tempWeb)
        self.navigationController!.pushViewController(tempWeb, animated: true)
        
    }
    
    // MARK: - Highlight selection
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView!, didDeselectItemAtIndexPath indexPath: NSIndexPath!) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.whiteColor()
    }
    
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView!, didHighlightItemAtIndexPath indexPath: NSIndexPath!) {
        let cell = self.collectionView.nodeForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.redColor()
    }
    
    func collectionView(collectionView: UICollectionView!, didUnhighlightItemAtIndexPath indexPath: NSIndexPath!) {
        let cell = self.collectionView.nodeForItemAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.whiteColor()
    }
    
    // What is the different there? static v.s. class
    static func name()->String {
        return "Explore"
    }

}
