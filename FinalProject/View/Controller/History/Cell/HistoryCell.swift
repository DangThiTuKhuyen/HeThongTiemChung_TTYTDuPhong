//
//  HistoryCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol HistoryCellDelegate: AnyObject {
    func cell(_ cell: HistoryCell, needPerform action: HistoryCell.Action)
}

final class HistoryCell: UITableViewCell {

    // MARK: - Enum
    enum Action {
        case goToDetail
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameDisease: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!

    // MARK: - Properties
    var viewModel: HistoryCellViewModel? {
        didSet {
            updateUI()
        }
    }
    weak var delegate: HistoryCellDelegate?

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
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

    // MARK: - Private func
    private func configUI() {
        // line dash
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.gray.cgColor
        lineLayer.lineWidth = 2
        lineLayer.lineDashPattern = [6, 4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 15, y: 0),
            CGPoint(x: 15, y: self.frame.height)])
        path.addLines(between: [CGPoint(x: 15, y: self.frame.height / 2),
            CGPoint(x: 30, y: self.frame.height / 2)])
        lineLayer.path = path
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameDisease.text = viewModel.histories.first?.disease?.diseaseName
        totalAmountLabel.text = "\(viewModel.histories.count)"
    }

    @objc private func goToDetail() {
        delegate?.cell(self, needPerform: .goToDetail)
    }

    @IBAction func goToDetailButton(_ sender: Any) {
        print("clicked")
        delegate?.cell(self, needPerform: .goToDetail)
    }
}
