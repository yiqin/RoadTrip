//
//  PostNewLiveStreamFeedViewController.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/30/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class PostNewLiveStreamFeedViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let statusPlaceHolder:String = "Say something ...."
    
    var statusTextView:UITextView = UITextView()
    
    /// This has not been setup yet.
    var locationNameButton: UIButton = UIButton(type: UIButtonType.System)
    
    var locationLabel:UILabel = UILabel()
    
    var addMorePhotoButton: UIButton = UIButton(type: UIButtonType.System)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createNavigationButtonItems()
        createStatusTextView()
        
        addMorePhotoButton.setTitle("Add More", forState: UIControlState.Normal)
        addMorePhotoButton.titleLabel?.textAlignment = NSTextAlignment.Right
        // MARK: - This doesn't work very well.
        // addMorePhotoButton.setBackgroundImage(UIImage(named: "ic_add_36pt"), forState: UIControlState.Normal)
        addMorePhotoButton.addTarget(self, action: "addAction", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addMorePhotoButton)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        createPickedImageViews()
    }
    
    
    func createNavigationButtonItems(){
        let sendBarButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "sendAction")
        navigationItem.rightBarButtonItem = sendBarButton
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelAction")
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    
    func createStatusTextView(){
        statusTextView.frame = CGRectMake(xPadding, yPadding*0.5, screenWidth-2*xPadding, 160)
        // statusTextView.placeholder = "Say something"
        statusTextView.text = statusPlaceHolder
        
        // statusTextField.backgroundColor = UIColor.redColor()
        statusTextView.font = UIFont(name: "Lato-Regular", size: 15)
        
        statusTextView.textColor = lightGrey
        
        statusTextView.layer.borderColor = lightWhite.CGColor
        statusTextView.layer.borderWidth = 1.0
        
        statusTextView.delegate = self
        
        view.addSubview(statusTextView)
    }
    
    
    func createPickedImageViews(){
        
        var tempX:CGFloat = xPadding
        let tempY:CGFloat = CGRectGetMaxY(statusTextView.frame)+yPadding
        let imageSize:CGFloat = (screenWidth-4*xPadding)/3
        
        for image in LiveStreamDataManager.sharedInstance.images {
            let imageView = UIImageView(frame: CGRectMake(tempX, tempY, imageSize, imageSize))
            imageView.clipsToBounds = true
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.image = image
            view.addSubview(imageView)
            
            tempX = tempX + imageSize + xPadding
        }
        
        
        addMorePhotoButton.frame =  CGRectMake(screenWidth-80-xPadding, tempY+imageSize-20, 80, 20)
        
        
        
        locationLabel.removeFromSuperview()
        
        locationLabel.frame = CGRectMake(3+xPadding, tempY+imageSize+yPadding*0.5, screenWidth-2*xPadding, 20)
        locationLabel.font = UIFont(name: "Lato-Regular", size: 13)
        locationLabel.text = "— at Chicago, IL"
        locationLabel.textColor = lightBlack
        locationLabel.textAlignment = NSTextAlignment.Left
        view.addSubview(locationLabel)
        
    }
    
    
    func sendAction() {
        if !LiveStreamDataManager.sharedInstance.isUploading {
            
            SVProgressHUD.showWithStatus("Uploading ...")
            
            LiveStreamDataManager.sharedInstance.status = statusTextView.text
            LiveStreamDataManager.sharedInstance.locationName = "Chicago, IL"
            LiveStreamDataManager.sharedInstance.postToParse { (success) -> () in
                
                NSNotificationCenter.defaultCenter().postNotificationName("reloadLiveStream", object: nil)
                SVProgressHUD.dismiss()
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
        }
    }
    
    
    func cancelAction() {
        if !LiveStreamDataManager.sharedInstance.isUploading {
            let alertController = UIAlertController(title: "Discard the changes?", message: "", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Leave", style: .Default) { (action) in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
        }
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == statusPlaceHolder {
            textView.text = ""
            textView.textColor = lightBlack
        }
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

    
}
