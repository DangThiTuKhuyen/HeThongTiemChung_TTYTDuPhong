//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        configTabbar()
        return true
    }

    // MARK: - Private func
    func configTabbar() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = []
        tabBarController.tabBar.tintColor = .black
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
}
