//
//  ChangePasswordViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class ChangePasswordViewController: ViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var oldPasswordTextField: UITextField!

    var viewModel: ChangePasswordViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
    }

    private func changePass() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.changePass { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.alert(msg: "Change your password succesfully", handler: nil)
                case .failure(let error):
                    this.alert(msg: error, handler: nil)
                }
            }
        }
    }

    @IBAction private func changePass(_ sender: Any) {
        guard let viewModel = viewModel, let oldPass = oldPasswordTextField.text, let newPass = newPasswordTextField.text else { return }
        if oldPass.isEmpty || newPass.isEmpty {
            alert(msg: "Please enter full information", handler: nil)
        } else {
            if oldPass == newPass {
                alert(msg: "Your new password must be different from your previous password", handler: nil)
            } else {
                viewModel.setNewPass(value: newPass)
                viewModel.setOldPass(value: oldPass)
                changePass()
            }
        }
    }
}
