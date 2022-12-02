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

final class LoginViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var hidePassButton: UIButton!
    @IBOutlet private weak var heightErrorLabel: NSLayoutConstraint!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    // MARK: - Override func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private func
    private func configUI() {
        setGradientBackground()
        iconImageView.image = UIImage.animatedImage(named: "vaccine")

        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.masksToBounds = true

        emailTextField.delegate = self
        emailTextField.configTextField()
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next

        passwordTextField.delegate = self
        passwordTextField.configTextField()
        passwordTextField.returnKeyType = .done

        hidePassButton.setImage(#imageLiteral(resourceName: "hide-show-pass"), for: .normal)
        hidePassButton.setImage(#imageLiteral(resourceName: "open-eye"), for: .selected)
        loginButton.layer.cornerRadius = 20
        showHideError()
    }

    override func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        let colorTop = #colorLiteral(red: 1.00, green: 0.98, blue: 0.96, alpha: 1.00).cgColor
        let colorBottom = #colorLiteral(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func showHideError(error: String = "", isShow: Bool = false) {
        errorLabel.text = error
        heightErrorLabel.constant = isShow ? 18 : 0
    }

    private func handleLogin() {
        guard let numberPhone = emailTextField.text, let password = passwordTextField.text else { return }
        if numberPhone.isEmpty || password.isEmpty {
            showHideError(error: "Please enter full information", isShow: true)
        } else {
            changeRoot(type: .tabbar)
        }
    }

    // MARK: - IBActions
    @IBAction private func hidePassButtonTouchUpInside(_ sender: UIButton) {
        hidePassButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }

    @IBAction private func handleLogin(_ sender: Any) {
        handleLogin()
    }

    @IBAction private func backToTutorialButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func createAccountButtonTouchUpInside(_ sender: UIButton) {
//        let registerVC = RegisterWithEmailViewController()
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            handleLogin()
        }
        return true
    }
}

// MARK: - UITextField
extension UITextField {

    func configTextField() {
        self.layer.borderWidth = 1
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
    }
}
