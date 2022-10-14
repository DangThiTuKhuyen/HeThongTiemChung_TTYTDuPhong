//
//  CommonCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class CommonCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var valueTextField: PaddingTextField!
    @IBOutlet private weak var leadingViewConstraint: NSLayoutConstraint!
    private let datePicker = UIDatePicker()
    var viewModel: CommonCellViewModel? {
        didSet {
            updateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        valueTextField.isUserInteractionEnabled = false
        valueTextField.delegate = self
    }

    private func updateCell() {
        guard let viewModel = viewModel, let type = viewModel.type else { return }
        switch type {
        case .district:
            leadingViewConstraint.constant = 45
            iconImageView.isHidden = true
        default:
            break
        }
        iconImageView.image = UIImage(named: viewModel.item?.image ?? "")
        valueTextField.placeholder = viewModel.item?.placeholder
    }

    private func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        valueTextField.inputAccessoryView = toolbar
        valueTextField.inputView = datePicker
    }

    @objc private func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        valueTextField.text = formatter.string(from: datePicker.date)
        self.endEditing(true)
    }

    @objc private func cancelDatePicker() {
        self.endEditing(true)
    }
}

extension CommonCell: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let viewModel = viewModel, let type = viewModel.type else { return false }
        switch type {
        case .name:
            break
        case .birthday:
            showDatePicker()
        case .province:
            break
        case .district:
            break
        case .email:
            break
        case .phoneNumber:
            valueTextField.keyboardType = .asciiCapableNumberPad
        case .gender:
            break
        case .password:
            break
        }
        return true
    }
}

