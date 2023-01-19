//
//  AppDelegate.swift
//  appname
//
//  Created by Fernando on 2020/09/29.
//

import UIKit
// import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dependency: AppDependency!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        dependency = dependency ?? CompositionRoot.resolve()
        dependency.configureAppearance()
        dependency.configureSDKs(application, launchOptions)
        dependency.configureMesseging(application, self)

        window = dependency.window

        return true
    }


    func application(_ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        dependency.openURL(url)
    }
}

//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        guard let fcmToken = fcmToken else { return }
//
//        logger.verbose("Firebase registration token >> \(fcmToken)")
//    }
//}

// MARK: Notification

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        dependency.registerDeviceToken(deviceToken)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        dependency.didReceiveRemoteNotification(application, userInfo, completionHandler)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        dependency.userNotificationCenterWillPresent(center, notification, completionHandler)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        dependency.userNotificationCenterDidReceive(center, response, completionHandler)
    }
}
