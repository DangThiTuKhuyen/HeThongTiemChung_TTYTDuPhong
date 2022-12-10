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
    
        guard let viewModel = viewModel else {
            return
        }
        contentLabel.text = viewModel.notify.notifyContent
        titleLabel.text = viewModel.notify.notifyTitle
    }
}
