//
//  CommonCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 12/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol CommonCellDataSource: AnyObject {
    func updateData(_ cell: CommonCell) -> String
}

final class CommonCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var valueTextField: PaddingTextField!
    @IBOutlet private weak var leadingViewConstraint: NSLayoutConstraint!
    var tableView = UITableView()
    private let datePicker = UIDatePicker()
    var viewModel: CommonCellViewModel? {
        didSet {
            updateCell()
        }
    }
    
    weak var dataSource: CommonCellDataSource?

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
//        valueTextField.isUserInteractionEnabled = false
        valueTextField.delegate = self
    }

    private func updateCell() {
//        if let dataSource = dataSource {
//            return dataSource.fxPickerView(self, titleForRow: row)
//        } else {
//            return ""
//        }
        guard let viewModel = viewModel, let type = viewModel.type, let dataSource = dataSource else { return }
        switch type {
        case .province:
            valueTextField.isUserInteractionEnabled = false
            valueTextField.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
            valueTextField.text = dataSource.updateData(self)
        case .district:
            valueTextField.isUserInteractionEnabled = false
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

    @objc private func showDropDown() {
        print("ffff")
    }
}
extension CommonCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }


}
extension CommonCell: UITableViewDelegate {

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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        delegate?.cell(self, needsPerformAction: .valueChanged(valueString: nameTextField.string.trimmedAllWhitespacesAndNewlines))
        textField.resignFirstResponder()
        return true
    }
}

