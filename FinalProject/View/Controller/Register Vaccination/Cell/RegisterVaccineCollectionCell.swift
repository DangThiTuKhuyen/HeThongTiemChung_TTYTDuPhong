//
//  RegisterVaccineCollectionCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 04/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RegisterVaccineCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var checkedImage: UIImageView!
    @IBOutlet private weak var vaccine: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var firmLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
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
        let treatment = viewModel.treatment
        vaccine.text = treatment.vaccine?.vaccineName
        checkedImage.isHidden = !viewModel.selected
        countryLabel.text = treatment.vaccine?.country
        amountLabel.text = treatment.amount?.toString()
        timeLabel.text = treatment.effect?.toString()
        priceLabel.text = treatment.vaccine?.vaccinePrice?.toString()
        firmLabel.text = treatment.vaccine?.firm
    }
}
