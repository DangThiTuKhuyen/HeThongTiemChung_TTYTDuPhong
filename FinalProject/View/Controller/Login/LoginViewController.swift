//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 06/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import GIFImageView
import SwiftUtils

final class LoginViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var hidePassButton: UIButton!
    @IBOutlet private weak var heightErrorLabel: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        let colorTop = #colorLiteral(red: 1.00, green: 0.98, blue: 0.96, alpha: 1.00).cgColor
        let colorBottom = #colorLiteral(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func configUI() {
        setGradientBackground()
        iconImageView.image = UIImage.animatedImage(named: "vaccine")

        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.masksToBounds = true

        phoneNumberTextField.delegate = self
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.layer.cornerRadius = 10
        phoneNumberTextField.layer.borderColor = UIColor.black.cgColor
        phoneNumberTextField.keyboardType = .asciiCapableNumberPad
        phoneNumberTextField.addTarget(self, action: #selector(changeColorTextField), for: .touchUpInside)
        phoneNumberTextField.returnKeyType = .next

        passwordTextField.delegate = self
        passwordTextField.layer.borderWidth = 1
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.returnKeyType = .done
        passwordTextField.addTarget(self, action: #selector(changeColorTextField), for: .touchUpInside)

        hidePassButton.setImage(#imageLiteral(resourceName: "hide-show-pass"), for: .normal)
        hidePassButton.setImage(#imageLiteral(resourceName: "open-eye"), for: .selected)
        loginButton.layer.cornerRadius = 20
        heightErrorLabel.constant = 0
    }

    @objc func changeColorTextField() {
    }

    @IBAction func hidePassButtonTouchUpInside(_ sender: UIButton) {
        hidePassButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }

    @IBAction func handleLogin(_ sender: Any) {
//        let detail = DetailViewController()
//        navigationController?.pushViewController(detail, animated: true)
    }

    @IBAction func backToTutorialButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonTouchUpInside(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneNumberTextField {
            passwordTextField.becomeFirstResponder()
        } else {
//            handleLogin()
        }
        return true
    }
}
