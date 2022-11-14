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
    @IBOutlet weak var vaccine: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

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
        vaccine.text = viewModel.vaccine.vaccineName
        checkedImage.isHidden = !viewModel.selected
        countryLabel.text = viewModel.vaccine.country
        amountLabel.text = viewModel.vaccine.amount?.toString()
        timeLabel.text = viewModel.vaccine.effect?.toString()
        priceLabel.text = viewModel.vaccine.price?.toString()
    }
}
