//
//  BirthdayCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 06/12/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol BirthdayCellDelegate: AnyObject {
    func cell(_ cell: BirthdayCell, needPerformAction action: BirthdayCell.Action)
}

final class BirthdayCell: UITableViewCell {

    // MARK: - Enum
    enum Action {
        case done(value: String, type: RegisterProfileType)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var valueTextField: UITextField!

    // MARK: - Properties
    private let datePicker = UIDatePicker()
    var viewModel: BirthdayCellViewModel? {
        didSet {
            updateCell()
        }
    }
    weak var delegate: BirthdayCellDelegate?

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.isUserInteractionEnabled = true
        valueTextField.borderStyle = .none
        valueTextField.delegate = self
    }

    private func updateCell() {
        valueTextField.text = viewModel?.item?.value
    }

    private func showDatePicker() {
        valueTextField.isUserInteractionEnabled = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        valueTextField.inputAccessoryView = toolbar
        valueTextField.inputView = datePicker
    }

    // MARK: - Objc func
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        valueTextField.text = formatter.string(from: datePicker.date)
        delegate?.cell(self, needPerformAction: .done(value: valueTextField.text ?? "", type: .birthday))
        self.endEditing(true)
    }

    @objc private func cancelDatePicker() {
        self.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension BirthdayCell: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showDatePicker()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueTextField.resignFirstResponder()
        return true
    }
}
