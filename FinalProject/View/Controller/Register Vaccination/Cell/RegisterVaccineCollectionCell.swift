//
//  RegisterVaccineCollectionCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RegisterVaccineCollectionCell: UICollectionViewCell {

    @IBOutlet weak var checkedImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }

    var viewModel: RegisterVaccineCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func configUI() {
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }

        checkedImage.isHidden = !viewModel.selected
    }
}
