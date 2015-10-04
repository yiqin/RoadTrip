//
//  AppDelegate.swift
//  RoadTrip
//
//  Created by Yi Qin on 5/26/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        checkNetworkingConnection()
        
        setupParse(launchOptions)
        setAppNavigationBar()
        
        setupSVProgressHUB()

        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = AppLaunchViewController(nibName: nil, bundle: nil)
        
        
        return true
    }
    
    // MARK: - check the network connection
    func checkNetworkingConnection(){
        Networking.checkConnection { (connection) -> Void in
            if connection {
                
            } else {
                let alertController = UIAlertController(title: "Network connection failed.", message: "The Internet connection appears to be offline.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    // Move to the main view controller
                    self.launchMainViewController()
                }
                alertController.addAction(cancelAction)
                
                self.window?.rootViewController!.presentViewController(alertController, animated: true) {
                    
                }
            }
        }
    }
    
    
    func setupParse(launchOptions: [NSObject: AnyObject]?){
        Parse.setApplicationId("uLSGUeCStE4p2wVVxgMIAhNiJEyn3ImYJcfhhN1E",
            clientKey: "De7xyUVfEqt0ov95ZUfnOA59CNhpYPxg35zXBw6e")
        
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: { (successed:Bool, error:NSError?) -> Void in
            
        })
        
        // MARK: - [Error]: invalid session token (Code: 209, Version: 1.7.4)
        // When we delete the app from Parse, it won't be able to load any data
        let currentUser = PFUser.currentUser()
        if (currentUser == nil) {
            PFAnonymousUtils.logInWithBlock({ (user:PFUser?, error:NSError?) -> Void in
                
            })
        }
    }
    
    // MARK: - Set the UI of navigation bar
    func setAppNavigationBar(){
        
        UINavigationBar.appearance().translucent = true
        
        UINavigationBar.appearance().barTintColor = lightWhite //lightWhite//UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = lightBlue // UIColor(red: 32.0/255, green: 32.0/255, blue: 32.0/255, alpha: 1.0)
        
        let navbarFont = UIFont(name: "OpenSans-Bold", size: 15.0) ?? UIFont.boldSystemFontOfSize(15)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navbarFont, NSForegroundColorAttributeName:lightBlue]
    }
    
    
    func setupSVProgressHUB() {
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.2, alpha: 1.0))
    }
    
    
    // MARK: - launch the main tab bar controller
    func launchMainViewController(){
        let main = MainTabBarController()
        self.window?.rootViewController = main
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "info.yiqin.RoadTrip" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("RoadTrip", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("RoadTrip.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

