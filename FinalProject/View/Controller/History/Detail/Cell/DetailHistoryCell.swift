//
//  DetailHistoryCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 20/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol DetailHistoryCellDelegate: AnyObject {
    func cell(_ cell: DetailHistoryCell, needPerformAction action: DetailHistoryCell.Action)
}

final class DetailHistoryCell: UITableViewCell {

    enum Action {
        case updateCell
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var numberDoseLabel: UILabel!
    @IBOutlet private weak var detailButon: UIButton!
    @IBOutlet private weak var heightDetailView: NSLayoutConstraint!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    weak var delegate: DetailHistoryCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    private func configUI() {
        // line dash
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.gray.cgColor
        lineLayer.lineWidth = 2
        lineLayer.lineDashPattern = [6, 4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 25, y: 0),
            CGPoint(x: 25, y: 89)])
        lineLayer.path = path
        
        containerView.layer.cornerRadius = 10
        detailView.layer.addSublayer(lineLayer)
        detailView.layer.masksToBounds = true
        heightDetailView.constant = detailButon.isSelected ? 89 : 0
        detailButon.setTitle("Hide", for: .selected)
        detailButon.setTitle("Show", for: .normal)
        iconImageView.layer.cornerRadius = 5
    }

    var viewModel: DetailHistoryCellViewModel? {
        didSet {
            updateCell()
        }
    }

    func updateCell() {
        guard let viewModel = viewModel else { return }
        detailButon.isSelected = viewModel.isShow
        heightDetailView.constant = detailButon.isSelected ? 89 : 0
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showHideDetail() {

    }

    @IBAction func showHideDetailButton(_ sender: Any) {
        delegate?.cell(self, needPerformAction: .updateCell)
    }
}
