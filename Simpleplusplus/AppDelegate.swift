//
//  AppDelegate.swift
//  Simpleplusplus
//
//  Created by Clement Chan on 10/17/16.
//  Copyright © 2016 Clement Chan. All rights reserved.
//

import UIKit
import Firebase
import Batch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Start Batch
        //Batch.start(withAPIKey: "DEV5805911AD95338EB397CDA0ED00") // dev
        Batch.start(withAPIKey: "5805911AD92366FDBBD35EE90C9E42") // live
        // Register for push notifications
        BatchPush.registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        FIRApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let devDeviceToken = ProfileLogin.phoneid
        if let pushClient = BatchClientPush(apiKey: "5805911AD92366FDBBD35EE90C9E42", restKey: "a524aa85f96b3bc103188428b026bd5b") {
            
            pushClient.sandbox = true
            pushClient.customPayload = ["aps": ["badge": 0] as AnyObject]
            pushClient.recipients.tokens.append(devDeviceToken)
            
            pushClient.send { (response, error) in
                if let error = error {
                    print("Something happened while sending the push: \(response) \(error.localizedDescription)")
                } else {
                    print("Push sent \(response)")
                }
            }
        }

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
