//
//  SceneDelegate.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftUtils

typealias HUD = SVProgressHUD

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    enum TypeScreen {
        case tutorial
        case tabbar
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        checkTime()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logout(_:)),
            name: NSNotification.Name(rawValue: "logOut"),
            object: nil)
    }

    func changeScreen(type: TypeScreen) {
        switch type {
        case .tutorial:
            createTutorial()
        case .tabbar:
            createTabbar()
        }
    }

    func checkTime() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            changeScreen(type: .tabbar)
        } else {
            changeScreen(type: .tutorial)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }

    private func createTabbar() {
        let homeVC = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeVC.viewModel = homeViewModel
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_fill"))

        let notifyVC = NotifyViewController()
        let notifyNavi = UINavigationController(rootViewController: notifyVC)
        notifyVC.tabBarItem = UITabBarItem(title: "Notification", image: #imageLiteral(resourceName: "notification"), selectedImage: #imageLiteral(resourceName: "notification_fill"))

        let profileVC = ProfileViewController()
        let profileViewModel = ProfileViewModel()
        profileVC.viewModel = profileViewModel
        let profileNavi = UINavigationController(rootViewController: profileVC)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))

        // configTabbar
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavi, notifyNavi, profileNavi]
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.backgroundColor = .white
        let tabbarView: UIView = UIView(frame: CGRect(x: 0, y: -15, width: kScreenSize.width, height: 150))
//        let scanQrButton: UIButton = UIButton(frame: CGRect(origin: CGPoint(x: (kScreenSize.width / 2) - 30, y: -45), size: CGSize(width: 60, height: 60)))
//        scanQrButton.setBackgroundImage(UIImage(named: "scanQR"), for: .normal)
//
//        scanQrButton.layoutIfNeeded()
//        scanQrButton.subviews.first?.contentMode = .scaleAspectFill
//        scanQrButton.layer.cornerRadius = 30
//        scanQrButton.layer.masksToBounds = true

        tabbarView.backgroundColor = .white
        let borderView: UIView = UIView(frame: CGRect(x: 0, y: 0.5, width: kScreenSize.width, height: 0.5))
        borderView.backgroundColor = .lightGray
        tabbarView.addSubview(borderView)
        tabBarController.tabBar.addSubview(tabbarView)
        tabBarController.tabBar.items?[1].badgeValue = "●"
        tabBarController.tabBar.items?[1].badgeColor = .clear
        tabBarController.tabBar.items?[1].setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
//        tabBarController.tabBar.addSubview(scanQrButton)
        tabBarController.tabBar.sendSubviewToBack(tabbarView)
        window?.rootViewController = tabBarController
    }

    private func createTutorial() {
        let tutorialVC = TutorialViewController()
        let tutorialViewModel = TutorialViewModel()
        tutorialVC.viewModel = tutorialViewModel
        window?.rootViewController = tutorialVC
    }

    private func setupController() {
        DispatchQueue.main.async {
            let navigationController = UINavigationController()
            let vc1 = LoginViewController.vc()
            navigationController.viewControllers.append(vc1)
            self.window?.rootViewController = navigationController
        }
    }

    @objc func logout(_ notification: Foundation.Notification) {
        if let info = notification.object as? JSObject,
            let isExpire = info["isExprire"] as? Bool,
            isExpire {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "", message: "Your login session has expired", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    self.handleLogOut()
                }))
            }
        } else {
            self.handleLogOut()
        }
    }

    private func handleLogOut() {
        let params = AuthService.Account(email: "khuyen.dang+38@monstar-lab.com", accessToken: "eyJraWQiOiJkZnE0QmpmbWcySmZFRDJhV1lTTUhqTHFyMEJYcjFtakQwcG1wakF5dTc4PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJhYWY4OWJhZS0xOGRhLTQ3NGMtYjVkNy1iMTFiMTg0YzFhN2EiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV81TDh2VTR6OVYiLCJjbGllbnRfaWQiOiI2MTY1NGwyaDZ2bjc2dXQ3MzkzNzhjb3E2aCIsIm9yaWdpbl9qdGkiOiJjOTdlYTExZS1mMThmLTQ5YTgtYjFjMi04MTE4NzU0NTNhNjciLCJldmVudF9pZCI6ImFlMGQ0Njg3LTM2MzgtNGRjNy05YThkLWJhMzFjZTUxNjEwYiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2NzA2NDEyNDMsImV4cCI6MTY3MDY0NDg0MywiaWF0IjoxNjcwNjQxMjQzLCJqdGkiOiI5NWY5NjVkNS02OWM4LTQ0ZmQtODQ5ZC04MTM1MGVkMDVkNDciLCJ1c2VybmFtZSI6ImFhZjg5YmFlLTE4ZGEtNDc0Yy1iNWQ3LWIxMWIxODRjMWE3YSJ9.aSM2NiOmmSN1LTrtCRRnd3ezp1F8kp3Gy6lTT0nMKpBKqu5Rj-BVNIDTjnM5WbKgoPdJ8WMKmti8vKEwPnQFhLwAXrTHDHP1F4nb8MoqUBxcDT1BjNO7rw0_e_gH_gZkGpdCBuIQP2tM3uY1kzD0JIY6skpsiFzidktRoECoAxq9OmPtzvomBy7IcCKYcIXpvYBDUaFJVKCW7wL0LTvuD7-NSnyWsXn7gFFn_USk-0hyITG0dxFtKvIZT0NNSqslSYn7or3yO6V4oYHvlkS5N-OfKBcz7MG-YpNcOPvyKuQghnjl-vFjUWIXaA52P6Ty0-rZO1S6PoqCgo9fmRZ4-g")
        AuthService.logout(params: params) { [weak self] result in
            guard let this = self else {
                return
            }
            switch result {
            case .success:
                this.setupController()
            case .failure(let error):
                print(error)
            }

        }
    }
}
