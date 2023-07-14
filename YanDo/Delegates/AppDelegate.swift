//
//  AppDelegate.swift
//  YanDo
//
//  Created by Александра Маслова on 24.06.2023.
//
// swiftlint:disable line_length
// swiftlint:disable unused_closure_parameter

import UIKit
import CocoaLumberjack
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoggerConfig.configureLogger()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    if granted {
                        print("Разрешение на отправку уведомлений получено")
                    } else {
                        print("Разрешение на отправку уведомлений отклонено")
                    }
                }
        return true
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
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let navigationController = window?.rootViewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            if visibleViewController is MainScreenViewController {
                return .portrait
            } else {
                return .all
            }
        }
        return .all
    }

}
// swiftlint:enable line_length
// swiftlint:enable unused_closure_parameter
