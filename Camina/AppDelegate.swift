//
//  AppDelegate.swift
//  Camina
//
//  Created by Shawn Chen on 2017-07-24.
//  Copyright © 2017 proximastech.com. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import UserNotifications
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //facebook sign-in configure
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //firebase database configure
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        setupFirstView()
        setNotification()
        

        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setNotification(){
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler:
            { granted, error in
                // handle the error if there is one
                // or something else in case the accept it
                if granted {
                    print("Notifications available")
                }
                
        })
        
        let playInfo = UNNotificationAction(identifier: "playInfo", title: "Play the information record", options: [.foreground])
        let appInfo = UNNotificationAction(identifier: "appInfo", title: "Open the app", options: [.foreground])
        
        let actionCategory = UNNotificationCategory(identifier: "actions", actions: [playInfo, appInfo], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([actionCategory])
    }
    
    func setupFirstView(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = CustomTabBarController()

  
    }
    

    
    
}


