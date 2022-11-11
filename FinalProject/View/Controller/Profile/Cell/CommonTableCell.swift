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
        case .name, .email, .numberPhone, .gender, .birthday, .province, .district:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
        case .province, .district:
            valueTextField.isUserInteractionEnabled = false
        }
    }

    func updateUI() {
        guard let viewModel = viewModel else { return }
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
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if viewModel?.type == .name {
//            valueTextField.isUserInteractionEnabled = selected
//            if selected {
//                valueTextField.becomeFirstResponder()
//            } else {
//                valueTextField.resignFirstResponder()
//            }
//        }
//    }

    func updateValueTextField() {
        valueTextField.resignFirstResponder()
        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: valueTextField.text ?? ""))
    }

}
