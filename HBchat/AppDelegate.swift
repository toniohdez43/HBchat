//
//  AppDelegate.swift
//  HBchat
//
//  Created by Antonio  Hernandez  on 4/24/16.
//  Copyright © 2016 Antonio  Hernandez . All rights reserved.
//

import UIKit
import xmpp_messenger_ios
import Quickblox



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func applicationDidEnterBackground(application: UIApplication) {
        QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
            
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        QBChat.instance().disconnectWithCompletionBlock { (error: NSError?) -> Void in
            
        }
        OneChat.stop()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        QBChat.instance().connectWithUser(QBSession.currentSession().currentUser!) { (error: NSError?) -> Void in
            
        }
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        QBSettings.setAccountKey("yjYy18hXswrqFSpHKbSj")
        //QBSettings.setApiEndpoint("https://api.quickblox.com", chatEndpoint: "chat.quickblox.com", forServiceZone: qbprod)
        QBSettings.setAuthKey("xnDkEMM7Lkc7dQe")
        
        QBSettings.setAuthSecret("fNEan7pyzXwXN5V")
        QBSettings.setApplicationID(40425)
        QBSettings.setAutoReconnectEnabled(true);
        // enabling carbons for chat
        QBSettings.setCarbonsEnabled(true)
        
        // Enables Quickblox REST API calls debug console output.
        QBSettings.setLogLevel(QBLogLevel.Nothing)
        
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        QBSettings.setKeepAliveInterval(40);
        
        // Override point for customization after application launch.
        OneChat.start(true, delegate: nil) { (stream, error) -> Void in
            if let _ = error {
                //handle start errors here
            } else {
                //Activate online UI
            }
            
        }
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
    
}