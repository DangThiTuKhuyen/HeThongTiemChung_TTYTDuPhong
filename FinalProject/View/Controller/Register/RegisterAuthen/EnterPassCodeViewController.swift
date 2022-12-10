//
//  EnterPassCodeViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 15/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class EnterPassCodeViewController: ViewController {

    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var tempPasscodeTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    var viewModel: EnterPassCodeViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        emailTextField.text = viewModel?.email
    }

    private func createAccount() {
        guard let viewModel = viewModel else {
            return
        }
        HUD.show()
        viewModel.createAccount { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.changeRoot(type: .tabbar)
                case .failure(let error):
                    this.alert(msg: error, handler: nil)
                }
            }
        }
    }
    
    private func showHideError(error: String = "", isShow: Bool = false) {
        errorLabel.text = error
        errorLabel.isHidden = !isShow
    }

    @IBAction func nextButton(_ sender: UIButton) {
        guard let viewModel = viewModel, let newPass = newPasswordTextField.text, let tempPass = tempPasscodeTextField.text else { return }
        if newPass.isEmpty || tempPass.isEmpty {
            showHideError(error: "Please enter full information", isShow: true)
        } else {
            showHideError()
            viewModel.setPassCode(value: tempPasscodeTextField.text ?? "")
            viewModel.setPassWord(value: newPasswordTextField.text ?? "")
            createAccount()
        }
        
    }

}
