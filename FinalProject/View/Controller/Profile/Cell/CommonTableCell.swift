//
//  CommonTableCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol CommonTableCellDelegate: AnyObject {

    func cell(_ cell: CommonTableCell, needsPerformAction action: CommonTableCell.Action)
}

final class CommonTableCell: UITableViewCell {

    enum Action {
        case valueChanged(valueString: String)
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!

    weak var delegate: CommonTableCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.borderStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        contentView.backgroundColor = .clear
        valueTextField.isHidden = false
    }

    var viewModel: CommonTableCellViewModel? {
        didSet {
            updateView()
        }
    }

    private func updateView() {
        guard let viewModel = viewModel, let type = viewModel.type else { return }
        switch type {
        case .avatar:
            break
        case .name, .identityCard, .email, .numberPhone, .gender, .birthday, .province, .district:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
//            valueTextField.isHidden = false
        case .changePass, .logout:
            titleLabel.text = viewModel.item?.title
            valueTextField.isHidden = true
        }
    }

    func updateUI() {
//        guard let viewModel = viewModel else { return }
//        nameContainerView.backgroundColor = viewModel.isSlelected ? Color.selectCellColor : .clear
        checkToUpdateKeyboardStatus()
    }

    private func checkToUpdateKeyboardStatus() {
        guard let viewModel = viewModel else { return }
        switch viewModel.type {
        case .name:
            valueTextField.isUserInteractionEnabled = viewModel.isSlelected
            if viewModel.isSlelected {
                valueTextField.becomeFirstResponder()
            } else {
                valueTextField.resignFirstResponder()
            }
        default:
            break
        }
    }

    func updateValueTextField() {
        valueTextField.resignFirstResponder()
        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: valueTextField.text ?? ""))
    }

}
