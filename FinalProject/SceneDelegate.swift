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
        case login
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
        case .login:
            let vc = LoginViewController()
            let viewModel = LoginViewModel()
            vc.viewModel = viewModel
            let vcNavi = UINavigationController(rootViewController: vc)
            window?.rootViewController = vcNavi
        }
    }

    func checkTime() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            if UserDefaults.standard.string(forKey: "userId")?.isNotEmpty ?? false {
                changeScreen(type: .tabbar)
            } else {
                changeScreen(type: .login)
            }
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
            let isExpire = info["isExpire"] as? Bool,
            isExpire {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Your login session has expired", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    UserDefaults.standard.reset()
                    self.setupController()
                }))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        } else {
            self.handleLogOut()
        }
    }

    private func handleLogOut() {
        let params = AuthService.Account(email: UserDefaults.standard.string(forKey: "email"), accessToken: UserDefaults.standard.string(forKey: "accessToken"))
        AuthService.logout(params: params) { [weak self] result in
            guard let this = self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    UserDefaults.standard.reset()
                    this.setupController()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
