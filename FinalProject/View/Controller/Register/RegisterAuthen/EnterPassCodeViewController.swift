//
//  EnterPassCodeViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 15/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class EnterPassCodeViewController: ViewController {

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
                    let vc = HomeViewController()
                    this.navigationController?.pushViewController(vc, animated: true)
                    break
                case .failure(let error):
                    break
                    print("fail")
//                    this.alert(msg: error, handler: nil)
                }
            }
        }
    }

    @IBAction func nextButton(_ sender: UIButton) {
        createAccount()
    }

}
