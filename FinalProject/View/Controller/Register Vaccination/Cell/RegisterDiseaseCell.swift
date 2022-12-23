//
//  RegisterDiseaseCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RegisterDiseaseCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!

    var viewModel: RegisterDiseaseCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.disease?.diseaseName
    }
}
