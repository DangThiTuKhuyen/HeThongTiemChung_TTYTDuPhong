//
//  RegisterWithEmailViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 15/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RegisterWithEmailViewController: ViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var viewModel = RegisterWithEmailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }

//    private func handleRegister() {
//        let email = emailTextField.text ?? ""
////        guard let viewModel = viewModel else { return }
//        HUD.show()
//        viewModel.registerAccount(email: email) { [weak self] result in
//            HUD.dismiss()
//            guard let this = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    this.pushToEnterPassCode()
//                case .failure(let error):
//                    this.alert(msg: error, handler: nil)
//                }
//            }
//        }
//
//    }

    private func pushToEnterPassCode() {
        let vc = EnterPassCodeViewController()
        vc.viewModel = EnterPassCodeViewModel(email: emailTextField.text ?? "")
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction private func goSignInButton(_ sender: Any) {
//        handleRegister()
    }

}
