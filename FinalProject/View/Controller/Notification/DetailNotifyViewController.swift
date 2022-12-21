//
//  DetailNotifyViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 17/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailNotifyViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    var viewModel: DetailNotifyViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        guard let viewModel = viewModel else { return }
        if viewModel.notify.status {
            contentLabel.text = viewModel.notify.notifyContent
            titleLabel.text = viewModel.notify.notifyTitle
        } else {
            updateStatus()
        }
    }

    func updateStatus() {
        guard let viewModel = viewModel else { return }
        viewModel.updateStatus { [weak self] result in
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.contentLabel.text = viewModel.notify.notifyContent
                    this.titleLabel.text = viewModel.notify.notifyTitle
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }
}
