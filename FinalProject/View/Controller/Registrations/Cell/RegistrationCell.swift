//
//  RegistrationCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 22/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol RegistrationCellDelegate: AnyObject {
    func cell(_ cell: RegistrationCell, needPerform action: RegistrationCell.Action)
}

class RegistrationCell: UITableViewCell {

    enum Action {
        case goToDetail
    }

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameDisease: UILabel!
    @IBOutlet private weak var vaccineLabel: UILabel!
    @IBOutlet private weak var acceptedView: UIView!
    
    var viewModel: RegistrationCellViewModel? {
        didSet {
            updateUI()
        }
    }

    weak var delegate: RegistrationCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 5
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 0.3
        containerView.layer.borderColor = UIColor.black.cgColor

        // shadow
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 4.0
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameDisease.text = viewModel.registration?.disease?.diseaseName
        vaccineLabel.text = viewModel.registration?.disease?.treatments?.first?.vaccine?.vaccineName
        acceptedView.isHidden = !(viewModel.registration?.status ?? false)
    }

    @IBAction private func goToDetailButton(_ sender: Any) {
        delegate?.cell(self, needPerform: .goToDetail)
    }
}
