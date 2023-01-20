// 
// CompositionRoot.swift
// tmsae
// 
// Created by bongzniak on 2022/08/21.
// Copyright 2022 tmsae. All rights reserved.
//

import Foundation
import UIKit

//import Firebase
//import AdSupport

import Common

import Splash
import Logger


struct AppDependency {
    typealias OpenURLHandler = (_ url: URL) -> Bool

    let window: UIWindow
    
    let configureSDKs: (
        _ application: UIApplication,
        _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Void
    let configureAppearance: () -> Void
    let configureMesseging: (
        _ application: UIApplication,
        _ delegate: UNUserNotificationCenterDelegate?
    ) -> Void
    
    let openURL: OpenURLHandler
    let applicationDidEnterBackground: () -> Void
    let applicationDidBecomeActive: () -> Void

    let registerDeviceToken: (_ deviceToken: Data) -> Void
    let didReceiveRemoteNotification: (
        _ application: UIApplication,
        _ userInfo: [AnyHashable : Any],
        _ completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) -> Void
    let userNotificationCenterWillPresent: (
        _ center: UNUserNotificationCenter,
        _ notification: UNNotification,
        _ completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) -> Void
    let userNotificationCenterDidReceive: (
        _ center: UNUserNotificationCenter,
        _ response: UNNotificationResponse,
        _ completionHandler: @escaping () -> Void) -> Void
}

final class CompositionRoot {
    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()

//        let presentLoginScreen: (() -> Void) = {
//
//        }
        
//        let presentMainScreen: (() -> Void) = {
//
//        }
        
        let navigationController: UINavigationController = BaseNavigationController()
        window.rootViewController = navigationController
        
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        splashCoordinator.start()

        return AppDependency(
            window: window,
            configureSDKs: configureSDKs,
            configureAppearance: configureAppearance,
            configureMesseging: configureMesseging,
            openURL: openURL(),
            applicationDidEnterBackground: applicationDidEnterBackground,
            applicationDidBecomeActive: applicationDidBecomeActive,
            registerDeviceToken: registerDeviceToken,
            didReceiveRemoteNotification: didReceiveRemoteNotification,
            userNotificationCenterWillPresent: userNotificationCenterWillPresent,
            userNotificationCenterDidReceive: userNotificationCenterDidReceive
        )
    }

    static func configureSDKs(
        _ application: UIApplication,
        _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {

    }

    static func configureAppearance() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithTransparentBackground()

            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithTransparentBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    static func configureMesseging(
        application: UIApplication,
        delegate: UNUserNotificationCenterDelegate?
    ) {
        // Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = delegate
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: {_, _ in }
        )
        application.registerForRemoteNotifications()
    }

    static func openURL() -> AppDependency.OpenURLHandler {
        { url -> Bool in
            logger.debug("url >> ", url)
            return true
        }
    }
}

extension CompositionRoot {
    static func applicationDidEnterBackground() {
    }

    static func applicationDidBecomeActive() {
    }
}

extension CompositionRoot {
    static func registerDeviceToken(_ deviceToken: Data) {
        // logger.debug("registerDeviceToken >> ", deviceToken)
    }

    static func didReceiveRemoteNotification(
        _ application: UIApplication,
        _ userInfo: [AnyHashable : Any],
        _ completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        logger.debug("didReceiveRemoteNotification userInfo >> ", userInfo)

        guard let userInfo = userInfo as? [String: AnyObject] else {
            return
        }
    }

    static func userNotificationCenterWillPresent(
        _ center: UNUserNotificationCenter,
        _ notification: UNNotification,
        _ completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        guard let userInfo = notification.request.content.userInfo as? [String: AnyObject] else {
            return
        }
        logger.debug("userNotificationCenterWillPresent userInfo >> ", userInfo)
        
        if #available(iOS 14.0, *) {
            completionHandler([[.sound, .banner]])
        } else {
            completionHandler([[.alert, .sound]])
        }
    }


    static func userNotificationCenterDidReceive(
        _ center: UNUserNotificationCenter,
        _ response: UNNotificationResponse,
        _ completionHandler: @escaping () -> Void
    ) {
        guard let userInfo = response.notification.request.content.userInfo as? [String: AnyObject]
        else { return }
        logger.debug("userNotificationCenterDidReceive userInfo\(userInfo)")
        completionHandler()
    }

}
