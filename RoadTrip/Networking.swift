//
//  Networking.swift
//  AppStore
//
//  Created by yiqin on 4/15/15.
//  Copyright (c) 2015 yiqin. All rights reserved.
//

import Foundation

public class Networking {
    
    public static let sharedInstance = Networking()
    
    // MARK: - Initilization
    public init() {
        
    }
    
    // MARK: - Request
    /**
    Creates a request for the specified method, URL string, parameters, and parameter encoding.
    
    - parameter method: The HTTP method.
    - parameter URLString: The URL string.
    - parameter parameters: The parameters. `nil` by default.
    - parameter encoding: The parameter encoding. `.URL` by default.
    
    - returns: The created request.
    */
    func get(request: NSURLRequest!, callback: (String, String?) -> Void) {
        
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                var result = NSString(data: data!, encoding: NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    
    class func checkConnection(callback: (Bool) -> Void) {
        // Request Google
        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.google.com")!)
        Networking.sharedInstance.get(request){ (data, error) -> Void in
            if error != nil {
                print(error)
                callback(false)
            } else {
                callback(true)
            }
        }
    }
}



