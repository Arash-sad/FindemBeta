//
//  AppDelegate.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 7/10/2015.
//  Copyright (c) 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import ParseFacebookUtilsV4

var pageToGo = ""
let trainingArray = ["Core Strength","Weight Loss","Functional Training","Small Group Training","Pre and Post Baby","Rehab"]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup Navigation Bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0)
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("iTvCqWwhq2x3pTvauMN3H5TdQChn8XOAsl0L8LJu",
            clientKey: "IbOyP5SZTovljexQnrS6GalxKrv9T48uGZOWcgtv")
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
                
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController:UIViewController
        let defaults = NSUserDefaults.standardUserDefaults()
        let appDirection = defaults.stringForKey("appDirection")
        
        if currentUser() != nil {
            if appDirection == "Trainer" {
                initialViewController = storyboard.instantiateViewControllerWithIdentifier("TrainerHomeNavController")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
            else if appDirection == "User" {
                initialViewController = storyboard.instantiateViewControllerWithIdentifier("FinderHomeNavController")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

