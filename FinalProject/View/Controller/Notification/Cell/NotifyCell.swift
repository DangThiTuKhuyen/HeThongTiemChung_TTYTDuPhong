//
//  NotifyCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 06/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol NotifyCellDelegate: AnyObject {
    func cell(_ cell: NotifyCell, needPerform action: NotifyCell.Action)
}

final class NotifyCell: UITableViewCell {

    enum Action {
        case goToDetail
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleType: UILabel!

    // MARK: - Properties
    var viewModel: NotifyCellViewModel? {
        didSet {
            updateUI()
        }
    }
    weak var delegate: NotifyCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.border(color: .black, width: 0.3)
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        titleType.text = viewModel.notify.titleType
        titleLabel.text = viewModel.notify.notifyTitle
        timeLabel.text = viewModel.notify.time
        containerView.backgroundColor = viewModel.notify.status ? .white : #colorLiteral(red: 1.00, green: 0.98, blue: 0.96, alpha: 1.00)
    }

    @IBAction private func detailButton(_ sender: Any) {
        delegate?.cell(self, needPerform: .goToDetail)
    }
}
