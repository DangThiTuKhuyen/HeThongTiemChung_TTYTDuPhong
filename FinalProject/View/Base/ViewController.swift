//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import UIKit
import MVVM
import SwiftUtils

class ViewController: UIViewController, MVVM.View {

    // Conformance for ViewEmptyProtocol
    var isViewEmpty: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.accessibilityIdentifier = String(describing: type(of: self))
        view.removeMultiTouch()
        setGradientBackground()
    }

    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: kScreenSize.height)
        let colorTop = #colorLiteral(red: 1.00, green: 0.98, blue: 0.96, alpha: 1.00).cgColor
        let colorBottom = #colorLiteral(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func changeRoot(type: SceneDelegate.TypeScreen) {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sceneDelegate.changeScreen(type: type)
        }
    }
}
