//
//  EnterPassCodeViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 15/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class EnterPassCodeViewController: ViewController {

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var tempPasscodeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
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
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    @IBAction func nextButton(_ sender: UIButton) {
        viewModel?.setPassCode(value: tempPasscodeTextField.text ?? "")
        viewModel?.setPassWord(value: newPasswordTextField.text ?? "")
        createAccount()
    }

}
