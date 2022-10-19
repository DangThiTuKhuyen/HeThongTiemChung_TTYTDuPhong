//
//  DistrictCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 16/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DistrictCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet private weak var iconSelectedImage: UIImageView!
    @IBOutlet private weak var label: UILabel!


    // MARK: - Properties
    var viewModel: DistrictCellViewModel? {
        didSet {
            updateCell()
        }
    }

    func updateCell() {
        guard let viewModel = viewModel else { return }
        label.text = viewModel.district.name
        iconSelectedImage.isHidden = !viewModel.selected
    }
}
