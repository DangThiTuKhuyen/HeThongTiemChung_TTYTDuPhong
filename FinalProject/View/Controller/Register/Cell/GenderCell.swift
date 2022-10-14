//
//  GenderCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class GenderCell: UITableViewCell {

    @IBOutlet private var multiRadioButton: [UIButton]! {
        didSet {
            multiRadioButton.forEach { (button) in
                button.setImage(#imageLiteral(resourceName: "circle_radio_unselected"), for: .normal)
                button.setImage(#imageLiteral(resourceName: "circle_radio_selected"), for: .selected)
            }
        }
    }
    @IBAction private func maleFemaleAction(_ sender: UIButton) {
        uncheck()
        sender.checkboxAnimation {
            print(sender.titleLabel?.text ?? "")
            print(sender.isSelected)
        }
        print(sender.tag)
    }
    func uncheck() {
        multiRadioButton.forEach { (button) in
            button.isSelected = false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIButton {

    func checkboxAnimation(closure: @escaping () -> Void) {
        guard let image = self.imageView else { return }
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false

        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                closure()
                image.transform = .identity
            }, completion: nil)
        }
    }
}
