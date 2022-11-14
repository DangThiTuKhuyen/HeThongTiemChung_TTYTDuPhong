//
//  DatePickerCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 13/11/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    private let datePicker = UIDatePicker()

    var viewModel: DatePickerCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateTextField.borderStyle = .none
        dateTextField.delegate = self
        dateTextField.attributedPlaceholder = NSAttributedString(
            string: "Choose date",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }

    private func updateUI() {
        titleLabel.text = viewModel?.item?.title ?? ""
    }

    private func showDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        let endDate: TimeInterval = 60 * 60 * 24 * 90
        let startDate: TimeInterval = 60 * 60 * 24 * 7
        datePicker.minimumDate = Date().addingTimeInterval(startDate)
        datePicker.maximumDate = Date().addingTimeInterval(endDate)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }

    @objc private func cancelDatePicker() {
        self.endEditing(true)
    }

    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
//        delegate?.cell(self, needPerformAction: .done(value: valueTextField.text ?? "", type: .birthday))
        self.endEditing(true)
    }

}

extension DatePickerCell: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let viewModel = viewModel, let type = viewModel.type else { return false }
        if type == .time {
            showDatePicker()
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: nameTextField.string.trimmedAllWhitespacesAndNewlines))
        textField.resignFirstResponder()
        return true
    }
}
