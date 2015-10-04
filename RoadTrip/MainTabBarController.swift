//
//  MainTabBarController.swift
//  Playground
//
//  Created by Yi Qin on 5/10/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.translucent = true
        tabBar.barTintColor = lightWhite
        tabBar.tintColor = lightRed
        
        
        // Live Streams and then Landmarks
        let vc2 = LiveStreamViewController(nibName: nil, bundle: nil)
        let navigationController2 = MainTabNavigationController(rootViewController: vc2)
        navigationController2.tabBarItem = UITabBarItem(title: LiveStreamViewController.name(), image: UIImage(named: "ic_local_movies"), tag: 0)
        
        
        let vc1 = LandmarksViewController(nibName: nil, bundle: nil)
        let navigationController1 = MainTabNavigationController(rootViewController: vc1)
        navigationController1.tabBarItem = UITabBarItem(title: LandmarksViewController.name(), image: UIImage(named: "ic_explore"), tag: 0)
        
        
        let vc3 = MyProfileViewController(nibName: nil, bundle: nil)
        let navigationController3 = MainTabNavigationController(rootViewController: vc3)
        navigationController3.navigationBarHidden = true
        navigationController3.tabBarItem = UITabBarItem(title: "Me", image: UIImage(named: "ic_person"), tag: 0)
        
        
        setViewControllers([navigationController2, navigationController1, navigationController3], animated: false)
        
        
    }
    


}
