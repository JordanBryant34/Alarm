//
//  AppDelegate.swift
//  Alarm
//
//  Created by Jordan Bryant on 9/14/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let alarmController = AlarmController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        alarmController.loadFromPersistentStore()
        requestNotificationsPermission()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (success, _) in
            if success {
                print("User allowed us to send alerts!")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

