//
//  AddressCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 14/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class ProvinceCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconSelectedImage: UIImageView!


    // MARK: - Properties
    var viewModel: ProvinceCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private func
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        label.text = viewModel.address.province
        iconSelectedImage.isHidden = !viewModel.selected
    }
}
