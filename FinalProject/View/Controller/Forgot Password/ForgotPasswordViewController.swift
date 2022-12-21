//
//  ForgotPasswordViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 07/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class ForgotPasswordViewController: ViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!

    // MARK: - Properties
    var viewModel: ForgotPasswordViewModel?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private func
    private func forgotPassword() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.forgotPassword { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.pushToConfirmCode()
                case .failure(let error):
                    this.alert(msg: error, handler: nil)
                }
            }
        }
    }

    private func pushToConfirmCode() {
        guard let viewModel = viewModel else { return }
        let vc = ConfirmCodeViewController()
        vc.viewModel = ConfirmCodeViewModel(email: viewModel.email)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showHideError(error: String = "", isShow: Bool = false) {
        errorLabel.text = error
        errorLabel.isHidden = !isShow
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // MARK: - IBActions
    @IBAction func goToConfirmCode(_ sender: Any) {
        guard let viewModel = viewModel, let email = emailTextField.text else { return }
        if email.isEmpty {
            showHideError(error: "Please enter your email", isShow: true)
        } else {
            if isValidEmail(email) {
                showHideError()
                viewModel.setEmail(value: emailTextField.text ?? "")
                forgotPassword()
            } else {
                showHideError(error: "Please enter correct email format", isShow: true)
            }
        }
    }
}
