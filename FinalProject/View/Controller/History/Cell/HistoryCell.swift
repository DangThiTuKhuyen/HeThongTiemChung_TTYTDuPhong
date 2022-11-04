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
    
    enum Action {
        case goToDetail
    }

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameDisease: UILabel!
    @IBOutlet private weak var nameVaccine: UILabel!
    
    weak var delegate: HistoryCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = 5
        containerView.layer.cornerRadius = 10
    }

    private func configUI() {
        
    }
    
    @objc private func goToDetail() {
        delegate?.cell(self, needPerform: .goToDetail)
    }
    
   
    @IBAction func goToDetailButton(_ sender: Any) {
        print("clicked")
        delegate?.cell(self, needPerform: .goToDetail)
    }
}
