//
//  AppDelegate.swift
//  Dating_App
//
//  Created by Clement Chan on 7/8/15.
//  Copyright (c) 2015 Clement Chan. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import Batch


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDelegate, UISearchBarDelegate{
    
    var window: UIWindow?
    
    var myViewController:ViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Include Batch
        Batch.start(withAPIKey: "577F39F55EDFB32D2A5AC16A8A3941")
        
        // Register for push notifications
        BatchPush.registerForRemoteNotifications()
        
        //For the purpose of Firebase authorization
        FIRApp.configure()
        
        return true
    }
    
    override init() {
        super.init()
        FIRApp.configure()
        // not really needed unless you really need it FIRDatabase.database().persistenceEnabled = true
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
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    }
    
    func registerForPushNotifications(application: UIApplication) {
    application.registerForRemoteNotifications(matching: [.alert, .sound, .badge])
    }
   
   
}

