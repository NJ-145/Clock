//
//  AppDelegate.swift
//  Clock
//
//  Created by imac-2626 on 2024/9/23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 通知許可
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if granted{
                print("Allow")
            } else {
                print("Don't Allow")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // 當通知即將顯示時觸發
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let identifier = notification.request.identifier
            
            // 刪除已顯示的通知
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
            print("通知已顯示並刪除")
            
            // 確保通知能夠正常顯示
            completionHandler([.alert, .sound, .badge])
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 使用新的 API 清除徽章數量
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("無法清除徽章數量：\(error)")
            }
        }
        // 刪除所有已送達的通知
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }


}

