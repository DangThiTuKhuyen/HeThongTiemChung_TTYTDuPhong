//
//  RegisterInfoCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class RegisterInfoCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var viewModel: RegisterInfoCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.attributedText = NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 174, green: 174, blue: 178, alpha: 1.0)])
    }

    private func updateUI() {
        guard let viewModel = viewModel, let item = viewModel.item, let type = viewModel.type else { return }
        switch type {
        case .medicalCenter:
            valueLabel.textColor = UIColor.black
        default:
            break
        }
        titleLabel.text = item.title
        valueLabel.text = item.value
    }
}
