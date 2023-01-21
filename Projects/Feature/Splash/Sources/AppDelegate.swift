//
//  AppDelegate.swift
//  Splash
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let navigationViewController = UINavigationController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        let splashCoordinator = SplashCoordinator(navigationController: navigationViewController)
        splashCoordinator.start()
        
        return true
    }
}
