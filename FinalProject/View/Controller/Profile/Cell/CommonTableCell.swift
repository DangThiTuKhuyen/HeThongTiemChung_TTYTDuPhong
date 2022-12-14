//
//  CommonTableCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 08/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

// MARK: - CommonTableCellDelegate
protocol CommonTableCellDelegate: AnyObject {
    func cell(_ cell: CommonTableCell, needsPerformAction action: CommonTableCell.Action)
}

final class CommonTableCell: UITableViewCell {

    enum Action {
        case valueChanged(valueString: String, type: ProfileType)
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var forwardImageView: UIImageView!
    @IBOutlet private weak var widthForwardImage: NSLayoutConstraint!

    var viewModel: CommonTableCellViewModel? {
        didSet {
            updateView()
        }
    }
    private let datePicker = UIDatePicker()
    weak var delegate: CommonTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.borderStyle = .none
        valueTextField.delegate = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        valueTextField.isHidden = false
        widthForwardImage.constant = 15
        titleLabel.textColor = .black
        valueTextField.inputView = .none
        valueTextField.inputAccessoryView = nil
        valueTextField.keyboardType = .asciiCapable
    }

    private func updateView() {
        guard let viewModel = viewModel, let type = viewModel.type else { return }
        switch type {
        case .avatar:
            break
        case .name, .identityCard, .email:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
            widthForwardImage.constant = 0
            valueTextField.isUserInteractionEnabled = false
        case .numberPhone, .birthday:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
            valueTextField.isUserInteractionEnabled = true
        case .gender, .province, .district:
            titleLabel.text = viewModel.item?.title
            valueTextField.text = viewModel.item?.value
            valueTextField.isUserInteractionEnabled = false
        case .changePass:
            titleLabel.text = viewModel.item?.title
            valueTextField.isHidden = true
        case .logout:
            titleLabel.text = viewModel.item?.title
            titleLabel.textColor = .red
            valueTextField.isHidden = true
            widthForwardImage.constant = 0
        }
    }

    private func showKeyBoard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        valueTextField.inputAccessoryView = toolbar
        valueTextField.keyboardType = .numberPad
        valueTextField.autocorrectionType = .no
    }

    private func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        valueTextField.inputAccessoryView = toolbar
        valueTextField.inputView = datePicker
    }

    @objc private func cancelDatePicker() {
        self.endEditing(true)
    }

    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        valueTextField.text = formatter.string(from: datePicker.date)
        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: valueTextField.text ?? "", type: .birthday))
        self.endEditing(true)
    }

    @objc private func done() {
        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: valueTextField.text ?? "", type: .numberPhone))
        self.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension CommonTableCell: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let viewModel = viewModel else { return false }
        if viewModel.type == .birthday {
            showDatePicker()
        } else {
            showKeyBoard()
        }
        return true
    }
}
