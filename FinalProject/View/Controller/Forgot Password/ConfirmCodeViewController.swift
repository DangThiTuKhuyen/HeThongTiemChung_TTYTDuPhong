//
//  ConfirmCodeViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 07/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class ConfirmCodeViewController: ViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var confirmCodeTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        guard let viewModel = viewModel else { return }
        emailTextField.text = viewModel.email
    }

    var viewModel: ConfirmCodeViewModel?

    private func resetPassword() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.resetPassword { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let alert = UIAlertController(title: "", message: "Reset password succesfully", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                        this.pushToLogin()
                    }))
                    this.present(alert, animated: true, completion: nil)
                case .failure(let error):
                    this.alert(msg: error, handler: nil)
                }
            }
        }
    }

    private func pushToLogin() {
        let vc = LoginViewController()
        vc.viewModel = LoginViewModel()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showHideError(error: String = "", isShow: Bool = false) {
        errorLabel.text = error
        errorLabel.isHidden = !isShow
    }

    @IBAction private func confirmResetPassButton(_ sender: Any) {
        guard let viewModel = viewModel, let newPass = newPasswordTextField.text, let confirmCode = confirmCodeTextField.text else { return }
        if newPass.isEmpty || confirmCode.isEmpty {
            showHideError(error: "Please enter full information", isShow: true)
        } else {
            showHideError()
            viewModel.setNewPassWord(value: newPass)
            viewModel.setConfirmationCode(value: confirmCode)
            resetPassword()
        }
    }
}
