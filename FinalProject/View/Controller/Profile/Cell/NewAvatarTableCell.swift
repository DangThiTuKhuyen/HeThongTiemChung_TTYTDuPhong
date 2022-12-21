//
//  NewAvatarTableCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol NewAvatarTableCellDelegate: AnyObject {
    func cell(_ view: NewAvatarTableCell, needsPerformAction action: NewAvatarTableCell.Action)
}

final class NewAvatarTableCell: UITableViewCell {

    enum Action {
        case edit
    }

    @IBOutlet private weak var avatarButton: UIButton!
    @IBOutlet private weak var iconPlus: UIImageView!

    // MARK: - Properties
    weak var delegate: NewAvatarTableCellDelegate?
    var viewModel: NewAvatarCellViewModel? {
        didSet {
            updateView()
        }
    }
    var avatarImage: UIImage? {
        didSet {
            avatarButton.setImage(avatarImage, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        iconPlus.layer.cornerRadius = 10.5
        iconPlus.layer.masksToBounds = true
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }
        avatarButton.downloadImage(with: viewModel.urlString ?? "") { image in
            if image != nil {
                self.avatarButton.setBackgroundImage(image, for: .normal)
            } else {
                self.avatarButton.setBackgroundImage(#imageLiteral(resourceName: "user.pdf"), for: .normal)
            }
        }
    }

    @IBAction func avatarButtonTouchUpInside(_ sender: Any) {
        delegate?.cell(self, needsPerformAction: .edit)
    }
}
