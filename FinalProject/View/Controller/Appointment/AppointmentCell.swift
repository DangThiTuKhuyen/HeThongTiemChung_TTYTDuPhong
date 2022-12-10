//
//  AppointmentCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol AppointmentCellDelegate: AnyObject {
    func cell(_ cell: AppointmentCell, needPerform action: AppointmentCell.Action)
}

final class AppointmentCell: UITableViewCell {

    enum Action {
        case goToDetail
    }

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var diseaseLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!

    var viewModel: AppointmentCellViewModel? {
        didSet {
            updateUI()
        }
    }
    weak var delegate: AppointmentCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
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
        diseaseLabel.text = viewModel.appointment.disease?.diseaseName
        dateLabel.text = "Time: " + (viewModel.appointment.registrationTime ?? "")
    }
    @IBAction private func goToDetailButton(_ sender: Any) {
        delegate?.cell(self, needPerform: .goToDetail)
    }
}
