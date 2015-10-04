//
//  DetailViewController.swift
//  Reading
//
//  Created by Yi Qin on 3/31/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView
    var progressView: UIProgressView!
    
    var indicatorColor:UIColor = lightBlack
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        webView = WKWebView()
        progressView = UIProgressView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: perform the deinitialization
    deinit {
        removeWebViewObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let settingButton = UIBarButtonItem(image: UIImage(named: "Setting"), style: UIBarButtonItemStyle.Plain, target: self, action: "clickSettingButton:")
        navigationItem.rightBarButtonItem = settingButton
        
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))
        webView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        view.addSubview(webView)
        
        let url = NSURL(string:"http://travel.nationalgeographic.com/travel/national-parks/grand-canyon-national-park/")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        
        progressView.frame = CGRectMake(0, 64, screenWidth, 4)
        progressView.tintColor = indicatorColor //RandomColorGenerator.getColor()
        
        view.addSubview(progressView)
        view.insertSubview(webView, belowSubview: progressView)
        
        // Bind webView to progressView
        addWebViewObserver()
    }
    

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func addWebViewObserver(){
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    func removeWebViewObserver(){
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    
    func clickSettingButton(sender:UIBarButtonItem!){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let CopyUrlAction = UIAlertAction(title: "Copy", style: .Default) { (action) in
            // UIPasteboard.generalPasteboard().string = self.feed!.urlString
        }
        alertController.addAction(CopyUrlAction)
        
        
        let destroyAction = UIAlertAction(title: "Report Abuse", style: .Destructive) { (action) in
            
            let alertController = UIAlertController(title: "投诉这篇文章", message: "We have received your report, and we are processing it now.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            /*
            var abuse = PFObject(className:"Abuse")
            abuse["title"] = self.feed!.title
            abuse["feed"] = self.feed!.parseObject
            abuse.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError?) -> Void in
                if (succeeded) {
                    self.presentViewController(alertController, animated: true) {
                        // ...
                    }
                }
            }
            */
        }
        alertController.addAction(destroyAction)
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    
}

    

