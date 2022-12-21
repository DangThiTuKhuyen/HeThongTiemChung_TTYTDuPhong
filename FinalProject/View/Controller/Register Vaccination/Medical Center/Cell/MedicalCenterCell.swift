//
//  MedicalCenterCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 23/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class MedicalCenterCell: UITableViewCell {

    @IBOutlet private weak var iconSelectedImage: UIImageView!
    @IBOutlet private weak var label: UILabel!

    // MARK: - Properties
    var viewModel: MedicalCenterCellViewModel? {
        didSet {
            updateCell()
        }
    }

    func updateCell() {
        guard let viewModel = viewModel else { return }
        label.text = viewModel.medicalCenter.name
        iconSelectedImage.isHidden = !viewModel.selected
    }
}
