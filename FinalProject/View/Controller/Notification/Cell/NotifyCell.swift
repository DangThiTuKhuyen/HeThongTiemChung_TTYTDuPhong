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

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    var viewModel: NotifyCellViewModel? {
        didSet {
            updateUI()
        }
    }
    weak var delegate: NotifyCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.border(color: .black, width: 0.3)
        containerView.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.96, alpha: 1.00)
    }

    private func updateUI() {
        guard let viewModel = viewModel else {
            return
        }
        titleLabel.text = viewModel.notify.notifyTitle
        timeLabel.text = viewModel.notify.time
    }

    @IBAction func detailButton(_ sender: Any) {
        delegate?.cell(self, needPerform: .goToDetail)
    }
}
