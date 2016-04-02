//
//  AppDelegate.swift
//  aggle
//
//  Created by Max Li on 3/3/16.
//  Copyright © 2016 Max Li. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import AWSCore



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //********service config for amazon aws (http://docs.aws.amazon.com/mobile/sdkforios/developerguide/setup.html )********
        
        
        
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId:"us-east-1:7c69fcfc-4487-4875-89d5-8ae91a01f2f7")
        
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        
        
        
        
        
        
        //***********   service config for amazon aws ends  *******************************
        
        let navBackgroundImage:UIImage! = UIImage(named: "GGnav.png")
        UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, forBarMetrics: .Default)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(application: UIApplication, openURL url: NSURL,
        sourceApplication: String?, annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance()
                .application(application, openURL: url,
                    sourceApplication: sourceApplication, annotation: annotation)
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
        
        FBSDKAppEvents.activateApp()                       // <---added by Jose Lemus
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
