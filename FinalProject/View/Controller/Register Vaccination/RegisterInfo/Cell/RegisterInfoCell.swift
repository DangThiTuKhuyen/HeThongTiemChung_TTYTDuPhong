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
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    private func updateUI() {
        guard let item = viewModel?.item else { return }
        titleLabel.text = item.title
        valueLabel.text = item.value
    }
}
