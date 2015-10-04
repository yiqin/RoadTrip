//
//  AppLaunchViewController.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/31/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class AppLaunchViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load config data from parse
        getConfigDataFromParse()
        
        let item1 = AppLaunchParallaxItem(image: UIImage(named: "backgroundImage1")!, text: "On The Road")
        let item2 = AppLaunchParallaxItem(image: UIImage(named: "backgroundImage4")!, text: "Explore the world through someone else's eye.")
        let item3 = AppLaunchParallaxItem(image: UIImage(named: "backgroundImage3")!, text: "Craft a beautiful story about your travel.")
        
        let parallaxViewController = AppLaunchParallax(items: [item1, item2, item3], motion: false)
        parallaxViewController.completionHandler = {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                parallaxViewController.view.alpha = 0.0
                
            }, completion: { (finished) -> Void in
                self.launchMainViewController()
            })
        }
        
        // Adding parallax view controller.
        self.addChildViewController(parallaxViewController)
        self.view.addSubview(parallaxViewController.view)
        parallaxViewController.didMoveToParentViewController(self)

    }
    
    
    func getConfigDataFromParse(){
        ConfigDataManager.sharedInstance.startToRetrieveConfig { () -> Void in
            // self.launchMainViewController()
        }

    }
    
    // MARK: - launch the main tab bar controller
    func launchMainViewController(){
        let main = MainTabBarController()
        UIApplication.sharedApplication().delegate?.window?!.rootViewController = main
    }

}
