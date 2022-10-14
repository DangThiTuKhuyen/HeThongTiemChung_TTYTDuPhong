//
//  AddressTableViewCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    let dummy = ["Đặng", "Thị", "Tú", "Khuyên"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: Bool = false {
        didSet {
            if viewModel == true {
                update()
            }
        }
    }
    
    func update() {
        label.text = dummy.first
    }
    
}
