//
//  LivestreamsViewController.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/26/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class LiveStreamViewController: UIViewController, YQViewControllerProtocol, ASCollectionViewDataSource, ASCollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var collectionView:ASCollectionView
    
    var liveStreamFeeds:[LiveStreamFeed] = []
    
    let refreshController = UIRefreshControl()
    
    
    var postNew:PostNewLiveStreamFeedViewController!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        collectionView = ASCollectionView(frame: CGRectZero, collectionViewLayout: MainCollectionViewFlowLayout(), asyncDataFetching: true)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        collectionView.backgroundColor = UIColor(red: 235.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0) // UIColor.whiteColor()
        
        collectionView.asyncDataSource = self
        collectionView.asyncDelegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadLiveStream", name: "reloadLiveStream", object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        createNavigationButtonItems()
        createRefreshControl()
        
        view.addSubview(collectionView)
        
        refreshControlAction()
        
        LiveStreamDataManager.loadChannels { (success) -> () in
            
        }
    }
    
    func customizeView(){
        title = LiveStreamViewController.name()
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    static func name()->String {
        return "Live Stream"
    }
    
    func createNavigationButtonItems(){
        let addBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addAction")
        navigationItem.rightBarButtonItem = addBarButton
        
        let changeChannelBarButton = UIBarButtonItem(image: UIImage(named: "ic_sort"), style: UIBarButtonItemStyle.Plain, target: self, action: "changeChannelAction")
        navigationItem.leftBarButtonItem = changeChannelBarButton
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
    
    func refreshControlAction(){
        loadDataFromParse()
    }
    
    func reloadLiveStream(){
        SVProgressHUD.showWithStatus("Loading ...")
        loadDataFromParse()
    }
    
    func loadDataFromParse(){
        
        LiveStreamDataManager.loadDataFromParse(0, completionClosure: { (success:Bool, hasMore:Bool, objects:[AnyObject]?) -> () in
            
            self.liveStreamFeeds = []
            
            if let tempObjects = objects as [AnyObject]? {
                for object in tempObjects {
                    let liveStreamFeed = LiveStreamFeed(parseObject: object as! PFObject)
                    self.liveStreamFeeds += [liveStreamFeed]
                }
            }
            
            SVProgressHUD.dismiss()
            self.collectionView.reloadData()
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "endRefreshControl", userInfo: nil, repeats: false)
        })
    }
    
    func endRefreshControl(){
        self.refreshController.endRefreshing()
    }
    
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return liveStreamFeeds.count
    }
    
    // MARK - call for cell in ASCollectionView
    func collectionView(collectionView: ASCollectionView!, nodeForItemAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let node = LiveStreamFeedCellNode(liveStreamFeed: liveStreamFeeds[indexPath.row])
        return node
    }
    
    func collectionView(collectionView: ASCollectionView!, willDisplayNodeForItemAtIndexPath indexPath: NSIndexPath!) {
        let node = collectionView.nodeForItemAtIndexPath(indexPath) as! LiveStreamFeedCellNode
        node.isDisplay = true
        node.display()
    }
    
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        print("select \(indexPath.row)")
        
        // When the user click this...
        
        
        
    }
    
    // MARK: Highlight selection
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView!, didDeselectItemAtIndexPath indexPath: NSIndexPath!) {
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
        // cell?.backgroundColor = UIColor.whiteColor()
    }
    
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView!, didHighlightItemAtIndexPath indexPath: NSIndexPath!) {
        let cell = self.collectionView.nodeForItemAtIndexPath(indexPath)
        // cell?.backgroundColor = UIColor.redColor()
    }
    
    func collectionView(collectionView: UICollectionView!, didUnhighlightItemAtIndexPath indexPath: NSIndexPath!) {
        let cell = self.collectionView.nodeForItemAtIndexPath(indexPath)
        // cell?.backgroundColor = UIColor.whiteColor()
    }

    
    /// Add action on the right navigation bar.
    func addAction() {
        let alertController = UIAlertController(title: nil, message: "Add moments to your live stream", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
            // ...
            
            let picker = UIImagePickerController()
            picker.delegate = self
            // picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(picker, animated: true, completion: { () -> Void in
                
            })
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "Choose from Photo Library", style: .Default) { (action) in
            print(action)
            
            let picker = UIImagePickerController()
            picker.delegate = self
            // picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(picker, animated: true, completion: { () -> Void in
                
            })
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    
    func changeChannelAction(){
        let alertController = UIAlertController(title: "You can create a new channel or switch to a new one", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Back", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let createNewChannelAction = UIAlertAction(title: "Create New Channel", style: UIAlertActionStyle.Destructive) { (action) -> Void in
            self.createNewChannel()
        }
        alertController.addAction(createNewChannelAction)
        
        let weakSelf = self
        for channel in LiveStreamDataManager.sharedInstance.channels {
            let OKAction = UIAlertAction(title: channel.title, style: .Default) { (action) in
                
                //MARK: - After the user select the new channel, we update it to NSUserDefaults and load new data from Parse
                NSUserDefaultsDataManager.sharedInstance.updateCurrentLiveStreamObjectId(channel.objectId as String)
                
                self.reloadLiveStream()
                weakSelf.title = channel.title
                weakSelf.navigationController!.title = "Live Stream"
            }
            alertController.addAction(OKAction)
        }
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    // MARK: - Craete New Live Channel
    func createNewChannel(){
        let alertController = UIAlertController(title: "Create your live stream channel", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Title"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        // MARK: - weak self is not perfect.
        let weakSelf = self
        let OKAction = UIAlertAction(title: "Create", style: .Default) { (action) in
            let textField = alertController.textFields![0] 
            let newChannelTitle:String = textField.text!
            LiveStreamDataManager.createNewChannelToParse(newChannelTitle, completionClosure: { (success) -> () in
                self.reloadLiveStream()
                weakSelf.title = newChannelTitle
                weakSelf.navigationController!.title = "Live Stream"
            })
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    
    // MARK: - image picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        LiveStreamDataManager.sharedInstance.addImage(image)
        
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.showPostNewLiveStreamFeedViewController()
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    
    func showPostNewLiveStreamFeedViewController(){
        
        // MARK :- Is it necessary to create a postNew as a property?
        if (postNew == nil) {
            postNew = PostNewLiveStreamFeedViewController(nibName: nil, bundle: nil)
        }
        
        let navigationController = MainTabNavigationController(rootViewController: postNew)
        navigationController.view.backgroundColor = UIColor.whiteColor()
        
        self.presentViewController(navigationController, animated: true, completion: { () -> Void in
            
        })
    }
    
    
}
