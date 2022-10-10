//
//  SceneDelegate.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import SVProgressHUD

typealias HUD = SVProgressHUD
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let tutorialVC = TutorialViewController()
        let tutorialViewModel = TutorialViewModel()
        tutorialVC.viewModel = tutorialViewModel

        let loginVC = LoginViewController()
        let loginNavi = UINavigationController(rootViewController: loginVC)

        let homeVC = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeVC.viewModel = homeViewModel
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_fill"))

        let searchVC = SearchViewController()
        let searchViewModel = SearchViewModel()
        searchVC.viewModel = searchViewModel
        let searchNavi = UINavigationController(rootViewController: searchVC)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search_fill"))

        let favoriteVC = FavoriteViewController()
        let favoriteViewModel = FavoriteViewModel()
        favoriteVC.viewModel = favoriteViewModel
        let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
        favoriteVC.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "favorite"), selectedImage: #imageLiteral(resourceName: "favorite_fill"))

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavi, searchNavi, favoriteNavi]
        tabBarController.tabBar.tintColor = .black
//        window.rootViewController = tabBarController
        window.rootViewController = tutorialVC
//        window.rootViewController = RegisterViewController()
        self.window = window
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        LocationManager.shared().request()
    }
}
